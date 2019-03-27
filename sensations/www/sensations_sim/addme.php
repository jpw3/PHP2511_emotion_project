<?php
include('lib.php');
include('settings.php');
session_start();
$data="";

$err=-1;

// check that we have all variables
//$keys=array('sex','age','nation','phobia');
$keys=array('sex','age','nation','born','phobia');
$keys=array('sex','age','nation','born','weight','height','hand','education','psychologist','psychiatrist','neurologist');
$errs = array('sex','age','nation','born','weight','height','hand','education','psychologist','psychiatrist','neurologist');

for($k=0;$k<count($keys);$k++){
    if(isset($_POST[$keys[$k]]))
    {
    $_SESSION[$keys[$k]]=$_POST[$keys[$k]];
    }
}
//prevent hacking to server from open questions

if(isset($_POST['nation'])||empty($_POST['nation'])){	
	$clean = htmlspecialchars($_POST['nation'], ENT_QUOTES);
	$_POST['nation'] = $clean;
}

for($k=0;$k<count($keys);$k++){
	$a[$k]=isset($_POST[$keys[$k]]);
    if(!isset($_POST[$keys[$k]]) )//|| empty($_POST[$keys[$k]]))
		{
    	$err=$k;
		}
}


if($err>=0)
	header("Location: register.php?err=$err");
else
{
for($k=0;$k<count($keys);$k++){
	if(isset($_POST[$keys[$k]]))
		$data.=$_POST[$keys[$k]]."\n";
}


$ok=0;
while($ok==0)
{
    $random = (rand()%999999);
	$random = $language.$random;
    if(is_dir("subjects/$random/"))
        $ok=0;
    else
    {
        $ok=1;
        system("mkdir subjects/$random/",$ret);
        if($ret==0)
        {               
            system("chmod 777 subjects/$random/",$ret);
            if($ret!=0)
                die("There was a disk error. Please email enrico.glerean@aalto.fi");
        }
    }
}
$techdata=var_export($_SERVER,TRUE);

$file="subjects/$random/data.txt";
$fh = fopen($file, 'w') or die("There was a disk error. Please email enrico.glerean@aalto.fi");
fwrite($fh, $data);
fclose($fh);

if(0) // needed for debugging only
{
$file="subjects/$random/techdata.txt";
$fh = fopen($file, 'w') or die("There was a disk error. Please email enrico.glerean@aalto.fi");
fwrite($fh, $techdata);
fclose($fh);
}

$file="subjects/$random/index.php";
$fh = fopen($file, 'w') or die("There was a disk error. Please email enrico.glerean@aalto.fi");
fwrite($fh, " ");
fclose($fh);

header("Location: session_sim.php?userID=$random");
}
?>
