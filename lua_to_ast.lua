
local lib = require "luadec"
local parser = require "lua-parser.parser"
local pp = require "lua-parser.pp"


local mod = {}



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



function dump (t)  
  
  for k,v in pairs(t) do
   if type(v) == "table" then
      dump(v)
   elseif k == "tag" and v == "Function" then
      getfunctionparams(t)   
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
         table.insert(mod.freevars, expBlock[1])
       expBlock.tag = "Number"
        expBlock[1] = v 
        print(v)
       
      end
    end
  end
end

function getupvalue( upvalueid )

      -- try local variables
      -- local i = 1
      -- while true do
      --   local n, v = debug.getlocal(caller, i)
      --   if not n then break end
      --   if n == upvalueid then
      --     value = v
      --     found = true
      --     print "LOCAL"
      --     return debug.getinfo(caller).func , i , value
          
      --   end
       
      --   i = i + 1
      -- end
      -- if found then return debug.getinfo(caller).func , i , value end



      -- try upvalues
        i = 1
        while true do
          local n, v = debug.getupvalue(caller, i)
          if not n then break end
          if n == upvalueid then  return func , i , v end
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



function mod.to_ast(func)

  caller = func 
  print( debug.getinfo(func,"n").name  )

  local code = "return " .. lib.luadec(func)
  
  local ast, error_msg = parser.parse(code, "exemplo1.lua")
  if not ast then
      print(error_msg)
      os.exit(1)
  end
 -- pp.print(ast)
   pp.dump(ast)
  dump(ast)
  findfreevars(ast[1])
  return ast
end

return mod