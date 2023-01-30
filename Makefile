MAKEFLAGS += --silent
SHELL=/bin/bash
R=$(shell git rev-parse --show-toplevel)

help: ## show help
	egrep -E '^[^[:space:]]+:.*## .*$$' $(MAKEFILE_LIST) | sort | awk ' \
		BEGIN {FS=":"; print "\nmake[OPTIONS]\n\nOPTIONS:\n"} \
	        {gsub(/^.*## /,"",$$2); printf "  \033[36m%-20s\033[0m %s\n",$$1,$$2}'

mds: ## update all markdowns 
	$(MAKE) $(addprefix $R/docs/,$(subst .lua,.md,$(shell ls *.lua)))

install: dotfiles  

dotfiles: vims  ## install all
	mkdir -p    $(HOME)/.config/ranger
	ln -sf $R/etc/vimrc     $(HOME)/.vimrc
	ln -sf $R/etc/rc.conf   $(HOME)/.config/ranger/rc.conf
	ln -sf $R/etc/bashrc    $(HOME)/.bashrc

vims: ~/.vim/bundle/Vundle.vim ## sub-routine. just install vim
	ln -sf $R/etc/vimrc $(HOME)/.vimrc

~/.vim/bundle/Vundle.vim:
	- [[ ! -d "$@" ]] && git clone https://github.com/VundleVim/Vundle.vim.git $@

H=awk  'BEGIN {RS="";FS="\n"} NR==1 {print; exit}' $R/README.md
B=awk 'BEGIN {RS="";FS="\n"} NR>1  {print "\n"; print}' 

zzz:
	$(foreach f, $(wildcard $R/docs/on*.md),\
		 echo "# $(notdir $f)"; $H>tmp;$B $f>>tmp;mv tmp $f;)

../docs/%.md: $R/docs/%.md
$R/docs/%.md: %.lua  ## make one markdown
		echo $@
	  $H  > $@
		printf "\n\n# "$^"\n\n" >> $@
		(echo "\`\`\`css" ) >> $@
		lua $^ -h  >> $@
		(echo "\`\`\`"; echo " ";)>> $@
		lua $R/src/alfold.lua $^  >> $@
		if [ -f "$R/etc/txt/$(basename $^).txt" ]; then echo "" >> $@; cat $R/etc/txt/$(basename $^).txt >> $@; fi

about:
	echo "lua 101"

~/tmp/%.html: %.lua  ## .lua ==> .html
	 docco -l classic -o ~/tmp $^
	 cp $R/etc/docco.css ~/tmp

# lib.md: ../4readme/readme.lua lib.lua  ## update lib.md
# 	echo "# $@"
# 	printf "\n# $(word 2,$^)\n\nMisc tricks.\n\n" > $@
# 	lua $< $(word 2,$^) >> $@
#
# 101.md: ../4readme/readme.lua 101.lua 101.txt ## update 101.md
# 	echo "# $@"
# 	printf "\n<img align=right width=300 src='etc/img/begin.jpg'>\n\n" > $@
# 	printf "\n# 101.lua\n\nBasic example of script idioms (test suites, help text).\n\n" >> $@
# 	(printf "\n\`\`\`css\n"; lua $(word 2,$^) -h ; printf "\`\`\`\n") >> $@
# 	lua $< $(word 2,$^) >> $@
# 	cat 101.txt >> $@
#
# about.md: ../4readme/readme.lua about.lua ## update about.md
# 	echo "# $@"
# 	gawk 'sub(/^## /,"")' Makefile > $@
# 	(printf "\n\`\`\`css\n"; lua about.lua -h ; printf "\`\`\`\n") >> $@
# 	lua $< about.lua >> $@
#
# changes to 3 cols and 101 chars/line
~/tmp/%.pdf: %.lua  ## .lua ==> .pdf
	mkdir -p ~/tmp
	echo "pdf-ing $@ ... "
	a2ps                 \
		-Br                 \
		--chars-per-line 100  \
		--file-align=fill      \
		--line-numbers=1        \
		--borders=no             \
		--pro=color               \
		--left-title=""            \
		--pretty-print="$R/etc/lua.ssh" \
		--columns  3                 \
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

