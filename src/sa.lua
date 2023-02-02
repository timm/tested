local b4={}; for k,v in pairs(_ENV) do b4[k]=v end 
math.randomseed(1)
local fmt,sort,map,oo,o,model,rand,r,rnds,rnd,x

function rand(t) return t.lo + r()*(t.hi-t.lo) end

function r() return math.random(10^9)/10^9 end

function rnd(n, nPlaces) 
  local mult = 10^(nPlaces or 2)
  return math.floor(n * mult + 0.5) / mult end

function rnds(t) return map(t,function(k,v) return rnd(v),k end) end 

function sort(t,fun) table.sort(t,fun); return t end

function map(t, fun,     fun1,u) 
  fun1 = debug.getinfo(fun).nparams==2 and fun or function(_,v) return fun(v) end
  u={}; for k,v in pairs(t) do v,k=fun1(k,v); u[k or (1+#u)]=v; end; return u end

fmt  = string.format
function oo(t) print(o(t)); return t end
function o(t)
  if type(t)~="table" then return tostring(t) end
  local function fun (k,v) return fmt(":%s %s",k,o(v)) end 
  return "{"..table.concat(#t>0  and map(t,o) or sort(map(t,fun))," ").."}" end
-----------------------------------------------------------------------------------
model={}
function model.Vienna()
  local f1,f2,f3
  function f1(t) return (t[1] - 2)^2 /2 + (t[2] + 1)^2 /13 + 3 end
  function f2(t) return (t[1] + t[2] - 3)^2 /175 + (2*t[2] -t[1])^2 /17 - 13 end
  function f3(t) return (3*t[1] - 2*t[2] + 4)^2 /8 + (t[1] - t[2] + 1)^2 /27 + 15 end
  return {x=  {a=  {lo=  -4, hi=  4},
               b=  {lo=  -4, hi=  4}},
          y=  {f1= {lo=   0, hi= 10, w="-1", get= f1},
               f2= {lo= -15, hi= -5, w="-1", get= f2},
               f3= {lo=  12, hi= 27, w="-1", get= f3}}, 
	 	     xGood= function(t,    g1,g2,g3)
				  		g1 = -1*t[2] - 4*t[1] + 4
					  	g2 = t[2] + 1            
						  g3 = t[2] - t[1] + 2
							return g1 >= 0 and g2 >= 0 and g3 >= 0 end} end

function model.xs(m) return map(m.x,rand) end

function model.ys(m,xs,      ys) 
   ys= map(m.y,function(k,details) 
                 local tmp = details.get(xs) 
                 return tmp,k end)
   if model.ok(m, xs,ys) then return ys end end

function model.ok(m,xs,ys)
   for k,y in pairs(ys) do
     if m.y[k].lo > y or y > m.y[k].hi then return nil end end 
   if m.xGood(xs) then return ys end end

for i=1,100 do 
  local m=model.Vienna()
  local xs = model.xs(m) 
  local ys = model.ys(m,xs)
  if ys then print(i, o(rnds(ys))) else io.write("-") end end

-- -- Initialize the temperature and cooling rate
-- local temperature = 100000
-- local cooling_rate = 0.003
--
-- -- Define a function to calculate the energy/cost of a given state
-- function energy(state)
--   -- implement the energy calculation here
--   return energy
-- end
--
-- -- Define a function to generate a random neighboring state
-- function random_neighbor(state)
--   -- implement the random neighbor generation here
--   return neighbor
-- end
--
-- -- Initialize the current state and best state
-- local current_state = initial_state
-- local best_state = current_state
--
-- -- Repeat until the temperature reaches a minimum value
-- while temperature > 1 do
--   -- Generate a random neighboring state
--   local neighbor = random_neighbor(current_state)
--   -- Calculate the energy/cost of the current state and the neighbor
--   local current_energy = energy(current_state)
--   local neighbor_energy = energy(neighbor)
--   -- Decide whether to move to the neighbor based on a probability
--   -- determined by the difference in energy and the temperature
--   if math.exp((neighbor_energy - current_energy) / temperature) > math.random() then
--     current_state = neighbor
--   end
--   -- Update the best state if the neighbor has lower energy
--   if neighbor_energy < energy(best_state) then
--     best_state = neighbor
--   end
--   -- Decrease the temperature
--   temperature = temperature * cooling_rate
-- end
--
-- -- Return the best state found
-- return best_state
for k,v in pairs(_ENV) do if not b4[k] then print(fmt("#W ?%s %s",k,type(v))) end end 
