include ../Makefile

FILES= china.csv auto93.csv  auto2.csv china.csv nasa93dem.csv coc1000.csv healthCloseIsses12mths0001-hard.csv \
       healthCloseIsses12mths0011-easy.csv SSN.csv SSM.csv pom.csv
eg1:
	for((b=10;b<=40;b=b+5)) do lua fish1.lua -b $$b -g learnssum; done 

eg2:
	for((b=1;b<=20;b=b+1)) do echo $$b ; lua xai.lua -s $$RANDOM -g xpln ; done

eg3:
	#lua xpln2.lua -H 512 -R -g xpln20 | column -s\& -t
	lua xpln2.lua -R -f ~/gists/data/auto2.csv -g xpln20 | column -s\& -t

eg4:
	$(foreach d,$(FILES), echo $d; lua xpln2.lua -R  -f ~/gists/data/$d -g xpln20 | column -s\& -t;)

