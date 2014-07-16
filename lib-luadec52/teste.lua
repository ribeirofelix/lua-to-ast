
local lib = require "luadec"

mlc = require 'metalua.compiler'.new()

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    for key, value in pairs (tt) do
      io.write(string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        io.write(string.format("[%s] => table\n", tostring (key)));
        io.write(string.rep (" ", indent+4)) -- indent it
        io.write("(\n");
        table_print (value, indent + 7, done)
        io.write(string.rep (" ", indent+4)) -- indent it
        io.write(")\n");
      else
        io.write(string.format("[%s] => %s\n",
            tostring (key), tostring(value)))
      end
    end
  else
    io.write(tt .. "\n")
  end
end


local y = 1
foo = function (x) return x + x end
local code = lib.luadec(foo)
print(code)
local ast = mlc:src_to_ast([[function a1(x) return x + x end]])
local a = mlc:ast_to_function(ast)
print(a(1))


