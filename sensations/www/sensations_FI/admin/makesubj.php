<html>
<head>
<title>Admin page</title>
<style>
*{
    margin:0px;
    padding:0px;
}

body{
    padding:10px;
    font-family:Helvetica, Arial, sans-serif;
    background:#dfd;
    border:1px solid #390;
    }


</style>
</head>
<body>
<div id="container">
<?php
$yes=$_POST["yes"];


if($yes==1)
{

	$random = (rand()%1000000);
	echo "Setting up user id <span style=\"font-size:20px;font-weight:bold\">$random</span><br><br>";
        if(is_dir("../subjects/$random/"))
		die("Error. Try again");
	system("mkdir ../subjects/$random/",$ret);
	if($ret==0)
	{
		
		system("chmod 777 subjects/$random/",$ret);
		if($ret==0)
			echo "User id <span style=\"font-size:20px;font-weight:bold\">$random</span> ready to annotate!";
			echo "<br>Copy the ID and go back to <a style=\"color:#360;font-weight:bold;\" href=\"../index.php\" target=\"_top\">home page</a>";
	}
	else
		echo "There was an error. Email enrico.glerean@aalto.fi";
}
else
{
?>

<form action="makesubj.php" method="POST">
	<input type="hidden" name="yes" value="1">
	<input type="submit" name="submit" value="generate id" />
</form>
<?php
}
include('footer.php');
?>
