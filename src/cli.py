"""
fish1,lua : sort many <x,y> things on y, after peeking at just a few y things
(c)2022 tim menzies <timm@ieee.org> bsd-2

note: fish1 is just a demonststraing of this kind of processing.
it is designed to be incomplete, to have flaws. if you look at this
case say say "a better way to do this wuld be xyz", then fish1 has
been successful.

usage: lua fish1.lua [options] [-g [actions

options:
  -b  --budget  number of evaluations = 16
  -f  --file    csv data file         = ../etc/data/auto93.csv
  -g  --go      start up action       = ls
  -h  --help    show help             = False
  -p  --p       distance coefficient  = 2
  -s  --seed    random number seed    = 10019
"""
import re,sys

def atom(s):
  "coerce a string to some type"
  s=s.strip()
  if s=="False": return False
  if s=="True":  return True
  try: return int(s)
  except:
      try: return float(s)
      except: return s

class o(object):
  "Simple class that creates get set methods for all fields. Also, can pretty print."
  def __init__(i, **d)  : i.__dict__.update(d)
  def __repr__(i) : return i.__class__.__name__ +"{"+', '.join(
    [f":{k} {v}" for k,v in sorted(list(i.__dict__.items())) if k[0] != "_"])+"}"

class settings(o):
  "Place to create settings from __doc__ and maybe update from command line."
  def create():
    "parse __doc__ string"
    pat=r"\n[\s]+-[\S]+[\s]+--([\S]+)[^\n]+= ([\S]+)"
    return settings(**{k:atom(v) for(k,v) in re.findall(pat,__doc__)})
  def update(i):
    "update settings from command-line"
    for k,v in i.__dict__.items():
      v=str(v)
      for n,x in enumerate(sys.argv):
        if x=="-"+k[0] or x=="--"+k:
          if    v=="False": v="True"
          elif  v=="True": v="False"
          else: v= sys.argv[n+1]
      i.__dict__[k] = atom(v)
    if i.help: print(__doc__); sys.exit()

the=settings.create()
if __name__ == "__main__":
    the.update()
    print(the)

# demo: try...
#              python3 cli.py -h -p 2322
