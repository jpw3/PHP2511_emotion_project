<?php
include('header.php');
include('../lib.php');
$key=trim($_POST['key']);
if($key=="1234")
{
    ?>
    <h1>Admin page</h1>
    <!--
	<h2>Create a new subject ID</h2>
    <iframe src="makesubj.php" frameborder=0 width=400 height=100>

    </iframe>
	-->
    <h2>Summary of data collected so far</h2>
    <br>
    <div style="top:0px;right:0px;position:absolute;color:#ccc"><a href="../index.php">Home page</a></div>

    <?php
    include("data.php");
}
else
    echo "<div class=\"error\">Wrong key.</div> <a href=\"index.php\">Go back</a>";

include('footer.php');
?>

