BEGIN {FS="\n"; RS=""}
/Creation/,/Examples/ && $1 ~/^function/ { print $1; F++}
/Creation/,/Examples/ && $1~/^function/{ lines=0; for(i=1;i<=NF;i++) {if ($i !~ /^--/) {lines++}}; sum=sum+lines; n++}
END {print sum, n, sum/n,F}
