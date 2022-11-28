<img src="img/banner.png">
 
```css

grud.lua : row/column clustering for rep grids
(c)2022, Tim Menzies <timm@ieee.org>, BSD-2 

Reads a csv file where row1 is column names and col1,coln
is dimension left,right and all other cells are numerics.

USAGE:   grid.lua  [OPTIONS]

OPTIONS:
  -d  --dump  on crash, dump stack       = false
  -f  --file  csv file                   = etc/data/repgrid1.csv
  -F  --Far   where to find far things   = 1
  -g  --go    start-up action            = data
  -h  --help  show help                  = false
  -m  --min   min size for leaf clusters = .5
  -p  --p     distance coefficient       = 2
  -s  --seed  random number seed         = 937162211
  -x  --X     small x change             = .1

```
 
# grid.lua
 

<dl>
<dt><b> LINE:new(raw, lhs:<tt>tab</tt>, rhs:<tt>tab</tt>) &rArr;  LINE </b></dt><dd>  constructor for a line. </dd>
<dt><b> LINE:__tostring() &rArr;  s </b></dt><dd>  generates pretty print string </dd>
<dt><b> LINE:normalize(lo, hi) &rArr;  nil </b></dt><dd>  generates `cells` from `raw` via normalization </dd>
<dt><b> LINE:__sub(other) &rArr;  n </b></dt><dd>  returns distance between two lines </dd>
<dt><b> LINE:far(lines:<tt>{LINE}</tt>) &rArr;  t </b></dt><dd>  return a pair that runes `the.Far` across `lines` </dd>
<dt><b> DATA:new(t:<tt>tab</tt>) &rArr;  DATA </b></dt><dd>  constructor for thing holding many lines. </dd>
<dt><b> DATA:add(line:<tt>LINE</tt>) &rArr;  nil </b></dt><dd>  add one `line`, update `lo` and `hi` for each numeric </dd>
<dt><b> DATA:normalize() &rArr;  nil </b></dt><dd>  normalizes raw numbers 0..1, min..max </dd>
<dt><b> DATA:furthest(lines:<tt>{LINE}</tt>) &rArr;  t </b></dt><dd>  return the largest west,east found in `lines` </dd>
<dt><b> DATA:half(lines:<tt>{LINE}</tt>) &rArr;  lines1,lines2,n </b></dt><dd>  divide lines on distance to 2 poles </dd>
<dt><b> DATA:tree(  lines:<tt>{LINE}</tt>?, min?) &rArr;  t </b></dt><dd>  returns `lines`, recursively bi-clustered. </dd>
<dt><b> eg.trees() &rArr;  nil </b></dt><dd>  Runs the whole analysis. </dd>
</dl>



## Example

1. Cluster attributes to find synonyms.

        Attributes:
        87
        |.. 72
        |.. |.. 34
        |.. |.. |.. f) OnlyActAsProgrammed :: Semi-autonomous
        |.. |.. |.. g) ConventionalSystem :: IntelligentSystem
        |.. |.. 60
        |.. |.. |.. e) ConventionalCommunication :: NovelCommunication
        |.. |.. |.. a) DevelopmentTool :: Application
        |.. 64
        |.. |.. 47
        |.. |.. |.. c) CommunicationTechnology :: ApplicationTechnology
        |.. |.. |.. b) Multimedia :: Programming
        |.. |.. 25
        |.. |.. |.. h) TargetedOnInterface :: TargetedOnOverallSystem
        |.. |.. |.. d) HumanOrientedTool :: SystemTool
        
2. Cluster examples to similarities.

        Examples:
        80
        |.. 63
        |.. |.. 20
        |.. |.. |.. j) BroadbandNetworks :: 
        |.. |.. |.. i) InformationHighway :: 
        |.. |.. 48
        |.. |.. |.. e) CrossPlatformGUIs :: 
        |.. |.. |.. 28
        |.. |.. |.. |.. c) MultimediaAndHypermedia :: 
        |.. |.. |.. |.. a) ElectronicPublishing :: 
        |.. 80
        |.. |.. 48
        |.. |.. |.. d) VisualProgramming :: 
        |.. |.. |.. b) VirtualReality :: 
        |.. |.. 71
        |.. |.. |.. f) ObjectOrientedSystems :: 
        |.. |.. |.. 42
        |.. |.. |.. |.. h) IntelligentAgents :: 
        |.. |.. |.. |.. g) KnowledgeBasedSystems :: 
        
3. Map examples onto a 2-by-2 grid
  
        Place:
        {a                                 b      }
        {                                         }
        {                                         }
        {                                         }
        {                                         }
        {                                         }
        {                                         }
        {                    d c                  }
        {                                         }
        {                  h                      }
        {          e   f                          }
        PASS ✅ on [trees]
