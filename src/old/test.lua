function obj(s,    t,new) --> t; create a klass and a constructor + print method
  local _id=0
  function new(k,...) 
    _id=_id+1
    local x=setmetatable({_id=_id},k); t.new(x,...); return x end
  t={_is=s, __tostring = tostring}
  t.__index = t;return setmetatable(t,{__call=new}) end

local COL=obj"COL"

function COL:new(a) self.a=a end

function COL:b(x) return self.a + x end 
a=COL(10); print(a:b(10))
a=COL(10); print(a:b(10))
a=COL(10); print(a:b(10))
a=COL(10); print(a:b(10))
a=COL(10); print(a:b(10))
a=COL(10); print(a:b(10))
a=COL(10); print(a:b(10))
a=COL(10); print(a:b(10))
a=COL(10); print(a:b(10))

