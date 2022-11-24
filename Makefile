-include ../etc/Makefile

about:
	echo "lua 101"

mds: lib.md 101.md about.md ## update all mds

lib.md: ../4readme/readme.lua lib.lua  ## update lib.md
	echo "# $@"
	printf "\n# $(word 2,$^)\n\nMisc tricks.\n\n" > $@
	lua $< $(word 2,$^) >> $@

101.md: ../4readme/readme.lua 101.lua 101.txt ## update 101.md
	echo "# $@"
	printf "\n<img align=right width=300 src='etc/img/begin.jpg'>\n\n" > $@
	printf "\n# 101.lua\n\nBasic example of script idioms (test suites, help text).\n\n" >> $@
	(printf "\n\`\`\`css\n"; lua $(word 2,$^) -h ; printf "\`\`\`\n") >> $@
	lua $< $(word 2,$^) >> $@
	cat 101.txt >> $@

about.md: ../4readme/readme.lua about.lua ## update about.md
	echo "# $@"
	gawk 'sub(/^## /,"")' Makefile > $@
	(printf "\n\`\`\`css\n"; lua about.lua -h ; printf "\`\`\`\n") >> $@
	lua $< about.lua >> $@

# changes to 3 cols and 101 chars/line
~/tmp/%.pdf: %.lua  ## .lua ==> .pdf
	mkdir -p ~/tmp
	echo "pdf-ing $@ ... "
	a2ps                 \
		-BR                 \
		--chars-per-line 100  \
		--file-align=fill      \
		--line-numbers=1        \
		--borders=no             \
		--pro=color               \
		--left-title=""            \
		--pretty-print="$R/etc/lua.ssh" \
		--columns  2                 \
		-M letter                     \
		--footer=""                    \
		--right-footer=""               \
	  -o	 $@.ps $<
	ps2pdf $@.ps $@; rm $@.ps    
	open $@


D=nasa93dem auto2 auto93 china coc1000 healthCloseIsses12mths0001-hard \
	healthCloseIsses12mths0011-easy pom SSN SSM

xys:
	$(foreach f,$D,printf "\n\n----[$f]-------------------\n"; \
		             lua keys.lua -f ../data/$f.csv -g xys;)

