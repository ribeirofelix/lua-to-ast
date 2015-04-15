local last = require "lua_to_ast"

local parser = require "lua-parser.parser"
local pp = require "lua-parser.pp"


local y = 1
local h = 2
local j = 1

-- function lol(  )
-- 	return function ()		 
-- 		return last.to_ast(function (x, z) return x + y + h + j end)
-- 	end
-- end 

--   ast = lol()()
-- local ast2 = lol()()
-- print(last.compile(ast2)(2,3))
ast1 = last.toAST(function ( x ) return x + y  end)

--pp.dump(ast,1)
last.print(ast1)

-- ast2 = last.to_ast(function ( x ) return x + h  end)

-- --pp.dump(ast,1)
-- pp.print(ast2)

local f1 = last.compile(ast1)
print(f1(5))

--last.teste()
-- h = 3
-- local f2 = last.compile(ast2)
-- print(f2(5))
-- print(f1(5))
