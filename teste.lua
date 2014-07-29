local last = require "lua_to_ast"

local parser = require "lua-parser.parser"
local pp = require "lua-parser.pp"



local y = 1 
local h = 2 
local j = 1

function lol(  )
	return function ()		 
		return last.to_ast(function (x, z) return x + y + h + j + g end)
	end
end 

 -- ast = lol()()
-- local ast2 = lol()()
ast = last.to_ast(function ( x ) return y + x  end)
print "Free variables:"
print(table.concat( last.freevars, ", " ))

--pp.dump(ast,1)
pp.print(ast)

