--!/usr/bin/lua

local docstrings = {}

function def(str)
  return function(obj) docstrings[obj] = str; return obj end
end

function help(obj)
  print(docstrings[obj])
end

f=def"asdas" (function(a,b) return a<b end)

print(help(f))
  f(3,4)
