<?php
// you can test how the function should work by running 
//	/var/www/bmldev.becs.aalto.fi/mobile_embody/analysis/run_makeFigsR2014a.sh /usr/local/MATLAB/MATLAB_Compiler_Runtime/v83/ /var/www/bmldev.becs.aalto.fi/mobile_embody/analysis/
// from shell 
include_once('settings.php');
include_once('header.php');
include_once('lib.php');?>

<div id="header">
<h1><?php echo $pagetexts['consent_title'];?></h1></div>
<div id="container">

<h2><?php echo $pagetexts['exp_title'];?></h2>
<br>
<p><?php echo $pagetexts['cons_form_link'];?>
<?php echo $pagetexts['consent_txt1'];?>  </p>
<br>
<div class="wrapper" style="text-align: center;">
<form method="POST" action="register.php">
<input type="submit" value="<?php echo $pagetexts['accept'];?>" >
</form>
<br><br>
<p><?php echo $pagetexts['consent_txt2'];?></p> </div>
<?php include('footer.php');?>
