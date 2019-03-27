<?php
include('settings.php');



function loadFolder($folder){
    $list=array();
    $allowed=array(
        "jpeg",
        "png",
        "gif",
        "jpg",
        "mp3",
        "flv",
        "JPEG",
        "PNG",
        "GIF",
        "JPG",
        "MP3",
        "FLV"
    );
    //List files in images directory
    $stat=exec("ls -t $folder",$files);
    foreach($files as $file)
    {
        if($file[0] == ".") continue;
        $temp=explode(".",$file);
        if(count($temp) == 2)
        {
            $extension=$temp[1];
            if(in_array($extension,$allowed))
                array_push($list,$file);
        }
    }
    return $list;
}

function loadTxt($file,$level){
    if(is_dir($file))
        return loadFolder($file);

    // the variable $level tells us if we have nested arrays, i.e. level 0 just a string, level 1 array split as |, level 2 array split as ,
    $fh=fopen($file,'r');
	if(!$fh)
	die("Invalid file ".$file);
    $list=array();
    while(!feof($fh))
    {   
    $line=trim(fgets($fh));
	if($line=="") continue;
        if($level==0)
            $out=$line;

        if($level>=1)
        {
            $arr=explode("|",$line);
            $out=$arr;
            if($level==2)
            {
                $tmparr=array();
                foreach($arr as $val)
                {
                    $subarr=explode(",",trim($val));
                    array_push($tmparr,$subarr);
                }
                $out=$tmparr;
            }
        }
        array_push($list,$out);
    }
    return $list;
}
    
function makePresentation($pfpath,$folderpath){
	if(0 == 1){
	$sets = loadTxt('./subjects/setorder.txt',0);
	$setnumber=$sets[0];
	$setID=$folderpath.'/setID.txt';
	$whichset=fopen($setID,'a');
	fwrite($whichset,'set'.$setnumber);
	fclose($whichset);
	
	$setfile=loadTxt('set'.$setnumber.'.txt',0);
	shuffle($setfile);
	$pfh=fopen($pfpath,'w');     // presentation file handle
	foreach($setfile as $line)
        fwrite($pfh,"$line\n");
    fclose($pfh);
	$order=fopen('./subjects/setorder.txt','w');
	if($setnumber<100){
		$setnumber=intval($setnumber)+1;
		fwrite($order,$setnumber);}
	else{
		$setnumber=1;
		fwrite($order,$setnumber);}
	fclose($order);
	}
    global $Nstimuli;
	$temp=array();
    $counter=0;
    for($c=0;$c<$Nstimuli;$c++)
    {
        $temp[$counter]=$c;
        $counter++;
    }
    shuffle($temp);
    $pfh=fopen($pfpath,'w');     // presentation file handle
    foreach($temp as $line)
        fwrite($pfh,"$line\n");
    fclose($pfh);
}

function initSim($outdatapath,$N){
	$timenow=time();
	$outstr="";
	//for($n=0;$n<$N;$n++){
	//	$x = rand(0,20)*20 + 200;
	//	$y = rand(0,80)*5 + 100;
	//	$outstr=$outstr."$x,$y,";
	//}

	$NN=ceil($N/3);
	$NNN=ceil(2*$N/3);
	for($n=0;$n<$N;$n++){
	if($n<$N/3)
      $temp[$n] = "$n*15+15".",0";
	else{
		if($n<2*$N/3)
			$temp[$n] = "($n-$NN)*15+15".",133";
		else
			$temp[$n] = "($n-$NNN)*15+15".",266";
			
		}
	}
	shuffle($temp);
	for($n=0;$n<$N;$n++){
		$xy=explode(',',$temp[$n]);
		$x=$xy[1];
		$y=$xy[0];
		$outstr=$outstr."$x,$y,";
	}



	
    //  $y = rand(0,80)*5 + 100;
    //  $outstr=$outstr."$x,$y,";
    //}


	$outstr=$outstr.$timenow."\n";
	$pfh=fopen($outdatapath,'w');     // outdata file handle
    fwrite($pfh,"$outstr");
    fclose($pfh);

	
}

function makePresentation_seq($seqpath,$folderpath,$userID,$NSEQ)
{
	global $Nstimuli;
	// current batch
	$pfh=fopen($folderpath.'/currbatch.csv','w');
	fwrite($pfh,"1\n");
	fclose($pfh);

	// presentation batches
	$ID=preg_replace("/[^0-9,.]/", "", $userID);
	$seqID=$ID%100;
	for($batch=1;$batch<=$NSEQ;$batch++)
	{
		$batch_presentation=loadTxt($seqpath.'/'.$seqID.'_'.$batch.'.csv',0);
		shuffle($batch_presentation);
		$pfpath=$folderpath.'/'.'presentation_'.$batch.'.csv';
		$pfh=fopen($pfpath,'w');
		foreach($batch_presentation as $line)
			fwrite($pfh,"$line\n");
		fclose($pfh);
	}
}

//finds a variable name in 'string' (enclosed in ##) and replaces it with var value
// var value comes from array, where the var name in string acts as a key
    function insertVarValues($string, $array){
        $which = 2;
        $splices = preg_split('/##/',$string);
		$output=isset($output)? $output: '';
        foreach ($splices as $part){
            if ($which%2) {
                $output.=$array[$part];
            } else {
                $output.=$part;
            }
            $which++;
        }
        return $output;
    };

	function loadPgTxt($file){
        if(is_dir($file))
            return loadFolder($file);
        $fh=fopen($file,'r');
        $list=array();
        while(!feof($fh))
        {
            $line = trim(fgets($fh));
            if(preg_match('/ \|\| /', $line)){
                $arr=preg_split('/ \|\| /',$line);
                $list[$arr[0]] = $arr[1];
            }
        }
        return $list;
    }
    function langFile($filename, $language){
        if ($language==''){
            $new_str = $filename;
        } else {
        $new_str = preg_replace('/(\.[^.]+)$/', sprintf('%s$1', '_'.$language), $filename);
        }
        return $new_str;
    };
