<?php
$d = opendir("../subjects/");
$allout=array();
$goodN=0;
while (false !== ($entry = readdir($d))) {
	if(substr($entry,0,1)==".")
		continue;
	if($entry == "index.php") 
		continue;
	$userID=$entry;
	$outstrID=str_pad($entry,8);
	$thisdir = new SplFileInfo("../subjects/$userID/index.php");
    $thisdate=date('Y/m/d H:i:s', $thisdir->getMTime());
	$outstr= "$thisdate\t|";
	
	//$outstr.="\t<a href=\"../subjects/$entry/\">$outstrID</a>\t|\t";
	$outstr.="\t$outstrID\t|\t";
	$pfpath='../subjects/'.$userID.'/presentation_1.csv';


	$haspres = is_file($pfpath);
	if(!$haspres)
	{
		$outstr.="NOT STARTED\n";
	}
	else
	{
		$annpath='../subjects/'.$userID.'/';
		$n=exec("ls $annpath|grep [0-9]_[1-5].csv|wc -l");
		$n=trim($n);
		$outstr.= "<b>$n</b> tokens completed\n";
		if($n>=20) $goodN++;
	}
	array_push($allout,$outstr);
}
echo "<pre>";
$N=sizeof($allout);
echo "Total num of subjects registered: ".$N."\n";
echo "Total num of usable subjects (at least 20 tokens): ".$goodN."\n\n";
echo "DATE\t\t\t|\tUSERID  \t|\tSTATUS\n";
echo "------------------------------------------------------------------------\n";

sort($allout);
foreach($allout as $outstr)
	echo $outstr;


echo "\n\n\n\n";
echo "</pre>";
echo "<h2>Other</h2>";
echo "- <a href=\"maketar.php\">Merge all files for download</a>"; 
echo "<br>";
echo "- <a href=\"../matlabfiles/\">Matlab script for reading ratings</a>";
