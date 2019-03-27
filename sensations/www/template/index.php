<?php
include_once('settings.php');
include_once('lib.php');

include('header.php');
?>
<div style="width:900px;height:40px;text-align:center;margin-left:auto;margin-right:auto;font-family:Montserrat,Helvetica,Arial,sans-serif;text-transform:uppercase;font-size:12px;line-height:20px;"><div style="width:300px;text-align:left;height:40px;float:left;">
<a href="http://emotion.nbe.aalto.fi/site/" ><img alt="Visit Nummenmaa Lab's website" title="Visit Nummenmaa Lab's website" height=40 src="http://emotion.nbe.aalto.fi/site/wp-content/uploads/2016/02/cover.png" style="float:left;"> Nummenmaa<br>Lab</a></div> 
<div style="width:300px;text-align:right;height:40px;float:right;"> <a href="http://www.aalto.fi/"><img alt="Aalto logo" height=40 src="http://bml.becs.aalto.fi/aivoleffa/aaltologo.png" title="Aalto University" style="float:right;">Aalto<br>University</a></div>
<div style="width:300px;text-align:center;height:40px;float:left;"><a href="http://nbe.aalto.fi/en/"><img alt="NBE logo" title="NBE" src="./images/nbelogo.png" height=40></a></div>
</div>
<div style="clear:both"></div>
<div id ="header">
<h1><?php echo $pagetexts['welcome'];?></h1>
</div>

<div id="container">
<?php echo $pagetexts['welcome_text'];?>
<form id="intro" method="GET" action="session_batch.php">
<div >


<?php echo $pagetexts['start'];?>

</div>
    <br><br><input  name="userID" type="text" onclick="this.value=''" value="<?php echo $pagetexts['continue'];?>"> 
</form>
<?php
include('footer.php');
?>
