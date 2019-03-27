<?php
include('lib.php');
include('settings.php');
    $userID=isset($_GET['userID'])?$_GET['userID']:'';
	//$perc=$_GET['perc'];
//echo $userID." ,";
    $currbatchID=isset($_GET['currbatchID'])?$_GET['currbatchID']:'';
    $presentation=isset($_GET['presentation'])?$_GET['presentation']:'';
//echo $presentation." ,";
    $d1 = $_GET['dim1'];
    $d2 = $_GET['dim2'];
    $d3 = $_GET['dim3'];
    $d4 = $_GET['dim4'];
    $d5 = $_GET['dim5'];
    $outfile='./subjects/'.$userID.'/'.$presentation.'_'.$currbatchID.'.csv';
    
    $fh = fopen($outfile, 'w') or die("<h1>Database error. Please contact enrico.glerean@aalto.fi</h1>");
    //$string = "fear $fear; disgust $disgust; valence $valence; arousal $arousal \n";
    $string=$d1.",".$d2.",".$d3.",".$d4.",".$d5."\n";
	fwrite($fh, $string);
    fclose($fh);



$prefile=loadTxt('./subjects/'.$userID.'/presentation_'.$currbatchID.'.csv',0);
$done=0;
    $annpath='./subjects/'.$userID.'/';
    foreach($prefile as $p)
    {
        if(is_file($annpath.trim($p)."_".$currbatchID.".csv"))
        {
            $done++;
        }
    }
	
	$amount=$done/(count($prefile));
    $amount=floor($amount*10000)/10000; // round to two points after percent decimal
    $perc=100*$amount;

if ($done != count($prefile)):
	header("Location: myvas.php?perc=$perc&userID=$userID&presentation=$prefile[$done]"."&currbatchID=$currbatchID");
else:
	header("Location: session_batch.php?userID=$userID&auto=1&currbatchID=$currbatchID");
endif;

?>


