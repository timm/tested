local b4={}; for k,v in pairs(_ENV) do b4[k]=v end -- lua trivia (used to find rogue locals)

function push(t, x) --> any; push `x` to end of list; return `x` 
  table.insert(t,x); return x end

function map(t, fun,     u) --> t; map function `fun`(k,v) over list (skip nil results) 
  u={}; for k,v in pairs(t) do k,v=fun(k,v); u[k or (1+#u)]=v; end; return u end

function coerce(s,    fun) --> any; return int or float or bool or string from `s`
  function fun(s1)
    if s1=="true" then return true elseif s1=="false" then return false end
    return s1 end
  return math.tointeger(s) or tonumber(s) or fun(s:match"^%s*(.-)%s*$") end

function csv(sFilename,fun,    src,s,t) --> nil; call `fun` on rows (after coercing cell text)
  src,s,t  = io.input(sFilename)
  while true do
    s = io.read()
    if   s
    then t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t]=coerce(s1) end; fun(t)
    else return io.close(src) end end end

function NUM(n,s)
  return {isNum=true, lo=math.huge, hi=-math.huge, at=n or 0, txt=s or 0,
          w=(s or ""):find"-$" and -1 or 1 } end

function SYM(n,s)
  return {at=n, txt=s,seen={}} end

 function COLS(row,     col)
   cols={names=row, all={},x={},y={}}
   for n,s in pairs(row) do  
     col = s:find"^[A-Z]+" and NUM(n,s) or SYM(n,s)
     push(i.all, col)
     if not s:find"X$" then
       if s:find"!$" then i.klass = col end
       push(s:find"[!+-]$" and i.y or i.x, col) end end 
   return cols end

 function DATA(src,    data)
   data={rows={}}
   if   type(src)=="string" 
   then csv(src,       function(row)   adds(data,row) end)
   else map(src or {}, function(_,row) adds(data,row) end) end
   return data end

 function adds(data,row)
   if   data.cols 
   then push(data.rows,row)
        for _,cols in pairs{data.cols.x, data.cols.y} do
          for _,col in pairs(cols) do
            add(col, row[col.at]) end end 
   else data.cols = COLS(row) end end  
        
function add(col,x)
  if x == "?" then return x end
  if    col.isNum 
  then  col.lo = math.min(x,col.lo)
        col.hi = math.max(x,col.hi)  
  else  col.seen[x] = true end

function dist1(col,x,y)
  if x=="?" and y=="?"then return 1 end
  x,y = norm(col,x), norm(col,y)
    
