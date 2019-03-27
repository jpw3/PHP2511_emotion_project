for folder in $(ls|grep F); do
	echo $folder
    p=1;
    fdate=$(date +"%Y%m%d%H%M.%S" -r $folder);
    mkdir -p replace/$folder
    touch -t "$fdate" replace/$folder
    while [ $p -le 5 ]; do
        file="presentation_"$p".csv";
        filedate=$(date +"%Y%m%d%H%M.%S" -r $folder/$file);
        newfile=replace/$folder/$file;
		echo -n "" > $newfile;
        for pp in $(cat $folder/$file); do
            let val=pp+1;
            if [ $val -eq 101 ]; then
                val=1;
            fi
            echo $val >> $newfile;
        done
        touch -t "$filedate" $newfile;
        let p=p+1;
    done
    for csvs in $(ls $folder/[0-9]*.csv); do
        filedate=$(date +"%Y%m%d%H%M.%S" -r $csvs); 
        id=$(echo $csvs|cut -d_ -f1|cut -d\/ -f2);
		echo $id;
		newid=$id;
        batch=$(echo $csvs|cut -d_ -f2);
        let newid=newid+1;
        newfile=replace/$folder/$newid"_"$batch;
        cp -pv $csvs $newfile;
        touch -t "$filedate" $newfile;
    done
	cp -rpv $folder/currbatch.csv replace/$folder
	cp -rpv $folder/index.php replace/$folder
	cp -rpv $folder/data.txt replace/$folder
    touch -t "$fdate" replace/$folder
done
