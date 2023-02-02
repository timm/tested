fmt  = string.format

function sort(t,fun) table.sort(t,fun) ;return t end
function key(x,t)   return type(x)=="string" and x or (1+#t) end
map  = function(t, fun) return kap(t, function(_,v) return fun(v) end) end
-- Map a function on table (results in items key1,key2,...)
function kap(t, fun,     u) 
  u={}; for k,v in pairs(t) do v,k=fun(k,v); u[k or (1+#u)]=v; end; return u end

function oo(t) print(o(t)); return t end
function o(t,    fun) 
  if type(t)~="table" then return tostring(t) end
  function fun (k,v) return fmt(":%s %s",k,o(v)) end 
  return "{"..table.concat(#t>0  and map(t,o) or sort(map(t,fun))," ").."}" end

local is={}
function is.vienna(t)
  local f1,f2,f3
  function f1(t) return (t[1] - 2)^2 /2 + (t[2] + 1)^2 /13 + 3 end
  function f2(t) return (t[1] + t[2] - 3)^2 /175 + (2*t[2] -t[1])^2 /17 - 13 end
  function f3(t) return (3*t[1] - 2*t[2] + 4)^2 /8 + (t[1] - t[2] + 1)^2 /27 + 15 end
  function get()
    return {x=  {a=  {lo=  -4, hi=  4},
                 b=  {lo=  -4, hi=  4}},
            y=  {f1= {lo=   0, hi= 10, w="-1", get= f1},
                 f2= {lo= -15, hi= -5, w="-1", get= f2},
                 f3= {lo=  12, hi= 27, w="-1", get= f3}}, 
	 			    ok= function(t,    g1,g2,g3)
				  				g1 = -1*t[2] - 4*t[1] + 4
					  			g2 = t[1] + 1            
						  		g3 = t[2] - t[1] + 2
							    return g1 >= 0 and g2 >= 0 and g3 >= 0 end} end


function rand(t) return t.lo + r()*(t.hi-t.lo) end

function r() return m.random(10^9)/10^9 end

function x(is) return map(is.x,within) end

-- Initialize the temperature and cooling rate
local temperature = 100000
local cooling_rate = 0.003

-- Define a function to calculate the energy/cost of a given state
function energy(state)
  -- implement the energy calculation here
  return energy
end

-- Define a function to generate a random neighboring state
function random_neighbor(state)
  -- implement the random neighbor generation here
  return neighbor
end

-- Initialize the current state and best state
local current_state = initial_state
local best_state = current_state

-- Repeat until the temperature reaches a minimum value
while temperature > 1 do
  -- Generate a random neighboring state
  local neighbor = random_neighbor(current_state)
  -- Calculate the energy/cost of the current state and the neighbor
  local current_energy = energy(current_state)
  local neighbor_energy = energy(neighbor)
  -- Decide whether to move to the neighbor based on a probability
  -- determined by the difference in energy and the temperature
  if math.exp((neighbor_energy - current_energy) / temperature) > math.random() then
    current_state = neighbor
  end
  -- Update the best state if the neighbor has lower energy
  if neighbor_energy < energy(best_state) then
    best_state = neighbor
  end
  -- Decrease the temperature
  temperature = temperature * cooling_rate
end

-- Return the best state found
return best_state

