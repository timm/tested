cat $1 | gawk '/^--/ {next} 1' | gawk '
BEGIN {FS="\n"; RS=""}
sub(/^[ \t]*$/,"") 
$1 !~ /^function/ {next}
/function COL\(/,/function accept\(/{ fun1++; lines1+= NF;next}
{ fun2++; lines2+= NF}
END {
   print "ai",fun1, line1s, lines1/fun1
   print "misc",fun2, lines2, lines2/fun2

 }'
