
local lib = require "luadec"
local parser = require "lua-parser.parser"
local pp = require "lua-parser.pp"

local comp = require "compile"

local function newclosure()
    local temp 
    return function () return temp end
end

local mod = {}

closures = {}
closurescnt = 0 



local ids = {}
mod.freevars = {}
function addToSet( key)
    ids[key] = true
end

function removeFromSet( key)
    ids[key] = nil
end

function setContains( key)
    return ids[key] ~= nil
end



function traverse (t)  
  
  for k,v in pairs(t) do
   if type(v) == "table" then
      traverse(v)
   elseif k == "tag" and v == "Function" then
      getfunctionparams(t)  
      findfreevars(t[2]) 
   end
  end

end

function findfreevars( expBlock )
  for k,v in pairs(expBlock) do
    if type(v) == "table" then
      findfreevars(v)
    elseif k == "tag" and v == "Id" then
      if not setContains(expBlock[1]) then
        local f , n, v = getupvalue(expBlock[1])  

          local fup = newclosure()

          debug.upvaluejoin(fup,1 , f , n )
          local cloname = "clo_" .. closurescnt
          closures[ cloname ] = fup 
          closurescnt = closurescnt +  1 

          expBlock.tag = "Call"
          expBlock[1] = { 
                  tag = "Index" , 
                  { tag =  "Id" , "closures"} ,
                  { tag = "String" , cloname } 
                  }


       
      end
    end
  end
end


function getupvalue( upvalueid )

      -- try upvalues
        i = 1
        while true do
          local n, v = debug.getupvalue(functotransf, i)
          if not n then break end
          if n == upvalueid then  return functotransf , i , v end
          print(n)
          i = i + 1
        end
end

function getfunctionparams( expFunc )
  if expFunc.tag == "Function" and expFunc[1].tag == "NameList" then
    for i = 1,#expFunc[1] do
      addToSet(expFunc[1][i][1])
    end
  end
 
end



function mod.toAST(func)

  functotransf = func 
 

  local code = "return " .. lib.luadec(func)
  print(code)
  local ast, error_msg = parser.parse( code , "exemplo1.lua")
  if not ast then
      print(error_msg)
      os.exit(1)
  end
 --pp.print(ast)
   pp.dump(ast)
   traverse(ast)
 
  return ast[1][1]
end


function mod.compile( ast )
   
  assert(type(ast) == "table")

  ast = {
    tag = "Block" ,
    { tag = "Return" , ast }

  }

  local code = comp.transalte(ast)
  print(code)
  return loadstring(code)()
end 

function mod.print( ast )
  print( pp.tostring {
    tag = "Block" ,
    { tag = "Return" , ast }

  } )
end 

return mod