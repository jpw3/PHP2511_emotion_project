<?php
include_once('./lib.php');
include_once('./settings.php');
include('./header.php');

if(array_key_exists('err',$_GET))
	$err=$_GET['err'];
//$err=isset($_GET['err']) ? $_GET['err']: '';
$countries=loadTxt('countries.txt',0);
if(isset($err))
{
    switch($err){    
        case 1:
            $msg=$pagetexts['rp_sex_err'];
            break;
        case 2:
            $msg=$pagetexts['rp_nation_err'];
            break;
    }
    $errormsg="<br><div class=\"error\">$msg</div><br><br>";
}

?>
<div id="header"><h1><?php echo $pagetexts['rp_title'];?> </h1></div>
<div id="container">
<style type="text/css">
td{
    padding:10px;
    }
input{
    margin-right:3px;
    }
</style>

<br>
<i>
<?php echo $pagetexts['rp_text']; ?>
</i>
<br>
<br>
<?php if(isset($errormsg)) echo $errormsg; ?>
<div class="centered">
<form method="POST" action="addme.php">
<table>
<tr style="background:#ccc">
        <td style="width:200px"><?php echo $pagetexts['rp_sex'];?></td>
        <td>
			<input type="radio" name="sex" value="0" <?php if(isset($_SESSION['sex']) && $_SESSION['sex']==="0"){?>checked="checked"<?php }?> > <?php echo $pagetexts['rp_male'];?>&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="sex" value="1" <?php if(isset($_SESSION['sex']) && $_SESSION['sex']==="1"){?>checked="checked"<?php }?>><?php echo $pagetexts['rp_female'];?>
        </td>
    </tr>
    <tr style="background:#eee">
        <td style="width:200px"><?php echo $pagetexts['rp_age'];?></td>
        <td>
            <select name="age">
            <?php
                for($i=18;$i<100;$i++){
                    $str="";
                    if(isset($_SESSION['age']) && $i==$_SESSION['age']) $str=" SELECTED ";
                    if($i==18 && !isset($_SESSION['age'])) $str=" SELECTED ";
                    echo "<option value=\"$i\"  $str>$i</option>";  
                }
            ?>
            </select>
        </td>
    </tr>
    <tr style="background:#ccc">
        <td style="width:200px"><?php echo $pagetexts['rp_nation'];?></td>
        <td>
			<select name="nation">
            <?php
                for($i=0;$i<count($countries);$i++){
                    $str="";
                    if(isset($_SESSION['nation']) && $i==$_SESSION['nation']) $str=" SELECTED ";
                    if($i==$countryID && !isset($_SESSION['nation'])) $str=" SELECTED ";
                    echo "<option value=\"".$countries[$i]."\"  $str>".$countries[$i]."</option>";
                }
            ?>
			</select>
			<!--<input type="text" name="nation" value=<?php echo isset($_SESSION['nation']) ? $_SESSION['nation']: '';?>>-->
        </td>
    </tr>

<tr style="background:#eee">
        <td style="width:200px"><?php echo $pagetexts['rp_born'];?></td>
        <td>
			<select name="born">
            <?php
                for($i=0;$i<count($countries);$i++){
                    $str="";
                    if(isset($_SESSION['born']) && $i==$_SESSION['born']) $str=" SELECTED ";
                    if($i==$countryID && !isset($_SESSION['born'])) $str=" SELECTED ";
                    echo "<option value=\"".$countries[$i]."\"  $str>".$countries[$i]."</option>";
                }
            ?>
			</select>
			<!--<input type="text" name="nation" value=<?php echo isset($_SESSION['nation']) ? $_SESSION['nation']: '';?>>-->
        </td>
    </tr>
	<tr style="background:#ccc">
        <td style="width:200px"><?php echo $pagetexts['rp_phobia'];?></td>
        <td>
			<input type="text" name="phobia" value="<?php echo isset($_SESSION['phobia']) ? $_SESSION['phobia']: '';?>">
        </td>
    </tr>

</table>
<br>
<input type="submit" value="<?php echo $pagetexts['rp_register'];?> ">
</form>
</div>
<?php
include('footer.php');
//?>
