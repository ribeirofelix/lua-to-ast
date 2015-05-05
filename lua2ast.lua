
local lib = require "luadec"
local parser = require "lua-parser.parser"
local pp = require "lua-parser.pp"
local comp = require "compile"

local lua2ast = {}

local function newclosure()
    local temp 
    return function () return temp end
end

local function get_upvalue(func, upvalueid)
  -- try upvalues
  local i = 1
  while true do
    local n, v = debug.getupvalue(func, i)
    if not n then break end
    if n == upvalueid then return func, i, v end
    i = i + 1
  end
end

local function find_free_vars(func, ids, expBlock)
  for k,v in pairs(expBlock) do
    if type(v) == "table" then
      find_free_vars(func, ids, v)
    elseif k == "tag" and v == "Id" then
      local name = expBlock[1]
      if not ids[name] then
        local f, n = get_upvalue(func, name)
        local fup = newclosure()
        debug.upvaluejoin(fup, 1, f, n)
        expBlock[2] = fup
        ids[name] = fup
      elseif type(ids[name]) == "function" then
        -- reuse closure
        expBlock[2] = ids[name]
      end
    end
  end
end

local function getfunctionparams(ids, expFunc)
  if expFunc.tag == "Function" and expFunc[1].tag == "NameList" then
    for i = 1,#expFunc[1] do
      ids[ expFunc[1][i][1] ] = "param"
    end
  end
end

local function traverse (func, ids, t)
  for k,v in pairs(t) do
    if type(v) == "table" then
      traverse(func, ids, v)
    elseif k == "tag" and v == "Function" then
      getfunctionparams(ids, t)
      find_free_vars(func, ids, t[2]) 
    end
  end
end

function lua2ast.toAST(func)
  local code = "return " .. lib.luadec(func)
  --print(code)
  local ast, error_msg = parser.parse( code , "exemplo1.lua")
  if not ast then
    return nil, error_msg
  end
  --pp.print(ast)
  --pp.dump(ast)
  local ids = {}
  traverse(func, ids, ast)
 
  return ast[1][1]
end

local function find_upvalues(ast, upvalues)
  if not upvalues then upvalues = {} end
  for k,v in pairs(ast) do
    if type(v) == "table" then
      find_upvalues(v, upvalues)
    elseif k == "tag" and v == "Id" then
      if ast[2] then
        upvalues[ast[1]] = ast[2]
      end
    end
  end
  return upvalues
end

local function join_upvalues(func, upvalues)
  for name, clo in pairs(upvalues) do
    local _, n = get_upvalue(func, name)
    debug.setupvalue(func, n, clo)
  end
end

function lua2ast.compile( ast )
  assert(type(ast) == "table")
  local upvalues = find_upvalues(ast)
  local out = {}
  for var, _ in pairs(upvalues) do
    out[#out+1] = " local "..var.."\n"
  end
  ast = {
    tag = "Block" ,
    { tag = "Return" , ast }
  }
  local astcode = comp.translate(ast)
  out[#out+1] = astcode
  local code = table.concat(out)
  local func = loadstring(code)()
  join_upvalues(func, upvalues)
  return func
end 

function lua2ast.print( ast )
  print( pp.tostring {
    tag = "Block" ,
    { tag = "Return" , ast }
  } )
end 

return lua2ast

