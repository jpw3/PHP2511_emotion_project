echo -n "" > allstudies
for n in $(cat -n nsdata.csv |sed "s/, /,/g"|tr '\t' ';'|sed 's/^ *//g'|sed 's/ /%20/g'|sed 's/$/,/g');
	do 
	id=$(echo $n|cut -d\; -f1);
	str=$(echo $n|cut -d\; -f2);
	a=1;
	temp="x";
	echo -n "">tempout
	while [ "x$temp" != "x" ];	do 
		temp=$(echo $str|cut -d, -f$a);
		if [ "x$temp" != "x" ]; then 
			#let's see if we have that page
			if [ -f ns_pages/$temp.html ]; then
				# echo "We already have ns_pages/$temp.html";
				aid=$(cat ns_pages/$temp.html |grep "var analysis"|grep -o  "\w[0-9].*\w");
				if [ -f ns_analyses/$aid.json ]; then
					#echo "We already have analysis for $aid $temp"
					nos=$(cat ns_analyses/$aid.json|grep [0-9]|wc -l);
					cat ns_analyses/$aid.json|grep [0-9]>>tempout;
					cat ns_analyses/$aid.json|grep [0-9]>> allstudies;
					echo $id"|"$a"|"$temp"|"$nos;
				else
					echo "We do not have aanalysis for $aid $temp"
					curl -o ns_analyses/$aid.json http://www.neurosynth.org/analyses/$aid/studies
					sleep 1
				fi
			else
				echo "We don't have ns_pages/$temp.html, let's download it";
				curl -o ns_pages/$temp.html http://www.neurosynth.org/analyses/terms/$temp/ 
				sleep 5
			fi
		fi;
		let a=a+1;
	done;
	totalnos=$(cat tempout|sort|uniq|wc -l);
	echo $id"|||"$totalnos;
done
