<?php
include_once('./settings.php');
include_once('./lib.php');
include('./header.php');
?>
<div id ="header">
<h1><?php echo $pagetexts['instr_title'];?></h1>
</div>
<div id="container">
<?php
if(isset($instructions)) {
            echo $instructions;

        }
;?>
</div>


