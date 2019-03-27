<?php
    include('settings.php');
    $userID=$_GET['userID'];
    $presentation=$_GET['presentation'];
	$perc=$_GET['perc'];
	$currbatchID=$_GET['currbatchID'];

	include('headervas.php');
?>

<script type="text/javascript" src="js/wz_dragdrop.js"></script>
<!-- wz_dragdrop.js (Dragdrop Bibliothek) is (c) Walter Zorn - see javascript source code for details -->
<script type="text/javascript" src="js/ratingscales.js"></script>
<!-- ratingscales.js (Ratingscales Addon) is (c) Timo Gnambs - see javascript source code for details -->
<!-- "wz_dragdrop.js" and "ratingscale.js" have to be included immediatly after "<body onload='next_page()'>" -->

<script type="text/javascript">
function v(f) {
    var isValid = false;
    var q = parseInt(f.dim1.value);
    var r = parseInt(f.dim2.value);
    var s = parseInt(f.dim3.value);
    var t = parseInt(f.dim4.value);
    var u = parseInt(f.dim5.value);
    if(isNaN(q) || q < 0) {
        alert("<?php echo $pagetexts['vas_answer_missing'];?>");
	f.dim1.focus();
        f.dim1.select();
    }else if(isNaN(r) || r < 0) {
        alert("<?php echo $pagetexts['vas_answer_missing'];?>"); 
	f.dim2.focus();
        f.dim2.select();  
    }else if(isNaN(s) || s < 0) {
        alert("<?php echo $pagetexts['vas_answer_missing'];?>");
	f.dim3.focus();
        f.dim3.select();    
    }else if(isNaN(t) || t < 0) {
        alert("<?php echo $pagetexts['vas_answer_missing'];?>");
	f.dim4.focus();
        f.dim4.select();
	}else if(isNaN(u) || u < 0) {
        alert("<?php echo $pagetexts['vas_answer_missing'];?>");
    f.dim5.focus();
        f.dim5.select();
    }else
        isValid = true;
    return isValid; // if isValid, the form will submit
}

</script>

<?php echo "<div id=\"headeralways\">".$pagetexts['sub_ID']." <span style=\"color:#fc0;font-weight:bold;\">".$userID."</span> <span style=\"margin-left:50px;margin-right:50px;\">".$pagetexts['done_perc']." ".$perc."%</span> <a href=\"ohjeet.php\" target=\"_blank\"><img  src=\"img/help-button.png\" width=\"15\" height=\"15\" alt=\"help\" title=\"help!\"></a></div>"; ?>

<div id="container">
<div style = "margin-top:40px;margin-bottom:20px;text-align:center;">
<br>
<?php echo $pagetexts['vas_instructions'];?>
<h1><?php echo $stimuliArray[$presentation]; ?></h1>
</div>
<form name="vas_data" action="writeVAS.php?" method="get" onsubmit="return v(this);">
<input type ="hidden" name="currbatchID" value=<?php echo $currbatchID; ?>>
<input type ="hidden" name="userID" value=<?php echo $userID; ?>>
<input type ="hidden" name="presentation" value=<?php echo $presentation; ?>>
        <table align="center" border="0">
<?php for($i=1;$i<=5;$i++){
	echo	"<tr>";
	echo "<td align=\"center\">";
	$hand="vas_dim".$i;
	$handjs="dim".$i;
	echo $pagetexts[$hand];
?>
		<img src="pics/pix.gif" border="0" alt="">
<script type="text/javascript">
scales.scale('<?php echo $handjs; ?>', 'click', 1000, ['pics/line00.gif', 600, 20], ['pics/00.gif'], ['<?php echo $pagetexts[$hand."_left"];?>','<?php echo $pagetexts[$hand."_right"];?>']);
</script>
</td>
</tr>
<?php
}
?>


<tr>
<td align="center">
<input type="submit" value="<?php echo $pagetexts['submit'];?>">
<br>
<br>
</tr>
</table>
</form>
</div>
    <script type="text/javascript">scales.init();</script>
<?php
include('footer.php');
