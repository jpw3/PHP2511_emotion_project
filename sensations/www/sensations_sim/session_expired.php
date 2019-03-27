<?php
include_once('settings.php');
include_once('lib.php');

include('header.php');
$userID=$_GET['userID'];
?>
<div id ="header">
<h1>Istuntosi on vanhentunut</h1>

<div id="container">
Istuntosi on vanhentunut. Voit jatkaa klikkaamalla <a href="http://emotion.becs.aalto.fi/sensations_sim/session_sim.php?userID=<?php echo $userID;?>">tästä</a>. 
<br><br>
Voit myös halutessasi kirjoittaa muistiin koehenkilötunnuksesi ID <b><?php echo $userID;?></b> jolloin voit jatkaa koetta kirjautumalla tunnuksellasi osoitteessa <a href="http://emotion.becs.aalto.fi/sensations_sim/">http://emotion.becs.aalto.fi/sensations_sim/</a>.
</div>

<?php
include('footer.php');
?>
