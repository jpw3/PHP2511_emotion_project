for n in $(ls -1 *.net); do
	cat $n |cut -d\  -f3|sed 's/-Infinity/0/g'|sed 's/[A-z]/0/g'|sed 's/-/E-/g'>$n".csv"
done
