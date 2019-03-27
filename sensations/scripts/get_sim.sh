file="sensations_modified.txt"
#for TYPE in "concept" "relation";do 
for TYPE in "concept";do 
	#for CORPUS in "webbase" "gigawords"; do
	for CORPUS in "gigawords"; do
		rm -i $TYPE"_"$CORPUS".net"
		for d1 in $(seq 1 100);do
			WORD1=$(sed "${d1}q;d" $file);
			for d2 in $(seq $d1 100); do
				if [ $d1 -eq $d2 ]; then continue; fi
				WORD2=$(sed "${d2}q;d" $file); 	
				#echo curl "http://swoogle.umbc.edu/SimService/GetSimilarity?operation=api\&phrase1=$WORD1\&phrase2=$WORD2\&corpus=$CORPUS\&type=$TYPE"
				num=$(curl -s http://swoogle.umbc.edu/SimService/GetSimilarity?operation=api\&phrase1=$WORD1\&phrase2=$WORD2\&corpus=$CORPUS\&type=$TYPE|tr -dc '[[:print:]]')
				sleep .05
				echo $d1 $d2 $num $WORD1 $WORD2
				echo $d1 $d2 $num $WORD1 $WORD2>> $TYPE"_"$CORPUS".net"
			done
		done
	done
done
