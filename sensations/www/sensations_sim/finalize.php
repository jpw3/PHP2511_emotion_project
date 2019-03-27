<?php
include_once('settings.php');
include_once('lib.php');

$userID=$_GET['userID'];
$file="subjects/$userID/0.csv";
$fh = fopen($file, 'w') or die("There was a disk error. Please email enrico.glerean@aalto.fi");
fwrite($fh, " ");
fclose($fh);

header("Location: session_sim.php?userID=$userID");


?>

