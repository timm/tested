l={}

function L(...)
  local out=""
  for _,s in pairs{...} do
    out=out.."local "..s.."=1; l['"..s.."']="..s..";\n" end
  return out end


print(L("a","b","c"))
load(L("a","b","c"))()

for k,v in pairs(l) do print(k,v) end

print(l.a)
