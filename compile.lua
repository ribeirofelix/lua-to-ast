
local trans = {}

local block2str, stm2str, exp2str, var2str
local explist2str, parlist2str, fieldlist2str

local function iscntrl (x)
  if (x >= 0 and x <= 31) or (x == 127) then return true end
  return false
end

local function isprint (x)
  return not iscntrl(x)
end

local function fixed_string (str)
  local new_str = ""
  for i=1,string.len(str) do
    char = string.byte(str, i)
    if char == 34 then new_str = new_str .. string.format("\\\"")
    elseif char == 92 then new_str = new_str .. string.format("\\\\")
    elseif char == 7 then new_str = new_str .. string.format("\\a")
    elseif char == 8 then new_str = new_str .. string.format("\\b")
    elseif char == 12 then new_str = new_str .. string.format("\\f")
    elseif char == 10 then new_str = new_str .. string.format("\\n")
    elseif char == 13 then new_str = new_str .. string.format("\\r")
    elseif char == 9 then new_str = new_str .. string.format("\\t")
    elseif char == 11 then new_str = new_str .. string.format("\\v")
    else
      if isprint(char) then
        new_str = new_str .. string.format("%c", char)
      else
        new_str = new_str .. string.format("\\%03d", char)
      end
    end
  end
  return new_str
end

local function name2str (name)
  return string.format('%s', name)
end

local function number2str (n)
  return string.format('%s', tostring(n))
end

local function string2str (s)
  return string.format('"%s"', fixed_string(s))
end

function var2str (var)
  local tag = var.tag
  local str 
  if tag == "Id" then
    if var[2] then
      -- this is an annotated upvalue.
      str =  name2str(var[1]).."()"
    else
      str =  name2str(var[1])
    end
  elseif tag == "Index" then
 
    str = exp2str(var[1]) 
    str = str .. "[" .. exp2str(var[2]) .. "]"

  else
    error("expecting a variable, but got a " .. tag)
  end
  return str
end

function parlist2str (parlist)
  local l = {}
  local len = #parlist
  local is_vararg = false
  if len > 0 and parlist[len].tag == "Dots" then
    is_vararg = true
    len = len - 1
  end
  local i = 1
  while i <= len do
    l[i] = var2str(parlist[i])
    i = i + 1
  end
  if is_vararg then
    l[i] = "..."
  end
  return  table.concat(l, ", ") 
end

function fieldlist2str (fieldlist)
  local l = {}
  for k, v in ipairs(fieldlist) do
    local tag = v.tag
    if tag == "Pair" then -- `Pair{ expr expr }
     
      l[k] = "[" .. exp2str(v[1]) .. "]" .. " = " .. exp2str(v[2])
     
    else -- expr
      l[k] = exp2str(v)
    end
  end
  if #l > 0 then
    return "{ " .. table.concat(l, ", ") .. " }"
  else
    return ""
  end
end

local optable = {
  add = "+" ,
  sub = "-" , 
  mul = "*" ,
  div = "/" ,
  mod = "%" ,
  pow = "^" ,
  concat = ".." ,
  eq = "==" ,
  lt = "<",
  le = "<=",
  ["and"] = "and" ,
  ["or"] = "or",
  ["not"] = "not",
  unm = "-",
  len = "#"
}

function exp2str (exp)
  local tag = exp.tag
  local str = " " .. tag:sub(1,1):lower() .. tag:sub(2)
  if tag == "Nil" or
     tag == "True" or
     tag == "False" then
  elseif tag == "Dots" then
    str = "..."
  elseif tag == "Number" then -- 
    str = " ".. number2str(exp[1])
  elseif tag == "String" then -- 
    str = " ".. string2str(exp[1])
  elseif tag == "Function" then -- 
    str = str .. "( "
    str = str .. parlist2str(exp[1]) .. ") "
    str = str .. block2str(exp[2])
    str = str .. " end"
  elseif tag == "Table" then -- `Table{ ( `Pair{ expr expr } | expr )* }
    str = fieldlist2str(exp)
  elseif tag == "Op" then -- `Op{ opid expr expr? } 
    str = ""
    str = str .. exp2str(exp[2]) .. " "
    str = str .. optable[name2str(exp[1])]
    if exp[3] then
      str = str .. exp2str(exp[3])
    end
  elseif tag == "Paren" then -- `Paren{ expr }
    str =  "( " .. exp2str(exp[1]) .. " )"
  elseif tag == "Call" then -- `Call{ expr expr* }
    str = ""
    str = str .. exp2str(exp[1])
    if exp[2] then
      for i=2, #exp do
        str = str .. ", " .. exp2str(exp[i])
      end
    end
    str = str .. "()"
  elseif tag == "Id" or -- `Id{ <string> }
         tag == "Index" then -- `Index{ expr expr }
    str = " " .. var2str(exp)
  else
    error("expecting an expression, but got a " .. tag)
  end
  return str
end

function explist2str (explist)
  local l = {}
  for k, v in ipairs(explist) do
    l[k] = exp2str(v)
  end
  if #l > 0 then
    return  table.concat(l, ", ") 
  else
    return ""
  end
end

function stm2str (stm)
  local tag = stm.tag
  local str = " " .. tag:sub(1,1):lower() .. tag:sub(2)
 
 
  if tag == "Return" then -- return <expr>* 
    str = str .. explist2str(stm)
  else
    error("expecting a statement, but got a " .. tag)
  end
  return str
end

function block2str (block)
  local l = {}
  for k, v in ipairs(block) do
    l[k] = stm2str(v)
  end
  return table.concat(l, "\n") 
end

function trans.translate (t)
  assert(type(t) == "table")
  return block2str(t)
end

return trans
