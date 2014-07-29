
local lib = require "luadec"
local parser = require "lua-parser.parser"
local pp = require "lua-parser.pp"



local y = 1
foo = function (x) return x + y end
local code = lib.luadec(foo)
print(code)

local ast, error_msg = parser.parse(code, "exemplo1.lua")
if not ast then
    print(error_msg)
    os.exit(1)
end

ids = {}

function dump (t)
  
  for k,v in pairs(t) do
   if type(v) == "table" then
      dump(v)
    else
      if k == "tag" and v == "Id" then
        getId(t)
      end
    end
  end
end

function getId( t )
  for k,v in pairs(t) do
    if type(k) == "number" then
       table.insert(ids,v)
    end
  end
end


dump(ast)
pp.dump(ast,1)
for k,v in pairs(debug) do
  print(k,v)
end

debug.upvaluejoin()

-- local y = 1
-- foo = function (x) return x - x end
-- local code = lib.luadec(foo)
-- print(code)

-- local y = 1
-- foo = function (x) return x * x end
-- local code = lib.luadec(foo)
-- print(code)


-- local y = 1
-- foo = function (x) return x / x end
-- local code = lib.luadec(foo)
-- print(code)


-- local y = 1
-- foo = function (x) return x .. x end
-- local code = lib.luadec(foo)
-- print(code)


-- local y = 1
-- foo = function (x) return x % x end
-- local code = lib.luadec(foo)
-- print(code)



-- local y = 1
-- foo = function (x) return  (#x + x - y) .. "lol" end
-- local code = lib.luadec(foo)
-- print(code)