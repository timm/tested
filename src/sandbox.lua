egs={}

help=""

fmt=string.format

help=help.."\nACTIONS:"
function eg(key,help1,fun)
  help = help..fmt("\n  -g  %s %s",key,help1)
  egs[1+#egs] = {key=key,fun=fun}  end 

eg("adas","asd asda sdas asd",function(x) 
  return x end)

print(help)
