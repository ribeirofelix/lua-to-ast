local lua2ast = require "lua2ast"

function boo()
   local y = 1
   local treesumY = lua2ast.toAST(function(x) return x + y end)
   y = y + 1
   lua2ast.print(treesumY)
   return treesumY
end

function foo()
   local y = 10
   local ret = boo()
   local f = lua2ast.compile(ret)
   print(f(40)) -- output: 42
end

foo()
