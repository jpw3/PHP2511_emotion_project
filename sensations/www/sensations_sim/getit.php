<?php

// TODO: adding secret key for increased security
$locations_arr=$_POST['locations'];
$locations=implode(',',$locations_arr);

if(array_key_exists('userID',$_POST))
	$uID=$_POST['userID'];
else
	die("0");


$timestamp=$_POST['timestamp'];
$file="subjects/$uID/outdata.csv";

// input verification if someone wants
//if(!isset($xt) || !isset($yt) || !isset($t) || !isset($mdt) || !isset($mut))     echo "ERROR: some variables are missing\n";

// let's build the text based on what we have

$mytext="$locations".",".$timestamp."\n";
$fh = fopen($file, 'a') or die("2");
fwrite($fh, $mytext);
fclose($fh);
echo "1";

