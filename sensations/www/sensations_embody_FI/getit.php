<?php
// TODO: adding secret key for increased security
$xt=$_POST['arrX'];
$yt=$_POST['arrY'];
$t=$_POST['arrTime'];
$xtd=$_POST['arrXD'];
$ytd=$_POST['arrYD'];
$td=$_POST['arrTimeD'];
$mdt=$_POST['arrMD'];
$mut=$_POST['arrMU'];
$file=$_POST['file'];
$currbatchID=$_POST['currbatchID'];
$presentation=$_POST['presentation'];


// input verification if someone wants
if(!isset($xt) || !isset($yt) || !isset($t) || !isset($mdt) || !isset($mut))
      echo "ERROR: some variables are missing\n";

// let's build the text based on what we have

$mytext="";
if(!empty($xt))
{

	for($c=0;$c<count($xt);$c++){
 	   $mytext.=$t[$c].",".$xt[$c].",".$yt[$c]."\n";
	}
}
// add a separator
$mytext.="-1,-1,-1\n";

// add the drawing data
if(!empty($xtd))
{	for($c=0;$c<count($xtd);$c++){
	    $mytext.=$td[$c].",".$xtd[$c].",".$ytd[$c]."\n";
	}
}
// add a separator
$mytext.="-1,-1,-1\n";

if(!empty($mdt))
{
	for($c=0;$c<count($mdt);$c++){
    	$mytext.=$mdt[$c].",,\n";
	}
}

// add a separator
$mytext.="-1,-1,-1\n";

if(!empty($mut))
{
	for($c=0;$c<count($mut);$c++){
        $mytext.=$mut[$c].",,\n";
	}
}   

$arr=explode('/',$file);     //0 is the ., 1 is subjects, 2 is subject id, 3 is the presentation file
$userID=$arr[2];

$outfile='./subjects/'.$userID.'/'.$presentation.'_'.$currbatchID.'.csv';

$fh = fopen($outfile, 'w') or die("2");
fwrite($fh, $mytext);
fclose($fh);
echo "1";

