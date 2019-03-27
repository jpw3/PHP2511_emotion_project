<?php
include_once('lib.php');
include_once('settings.php');
include('header.php');
$keys=array('sex','age','nation','born','weight','height','hand','education','psychologist','psychiatrist','neurologist');

if(array_key_exists('err',$_GET))
	$err=$_GET['err'];

$countries=loadTxt($countriesfile,0);
if(isset($err))
{
 /*   switch($err){    
        case 0:
            $msg=$pagetexts['rp_sex_err'];
            break;
        case 1:
            $msg=$pagetexts['rp_age_err'];
            break;
        case 2:
            $msg=$pagetexts['rp_weight_err'];
            break;
        case 3:
            $msg=$pagetexts['rp_height_err'];
            break;
        case 4:
            $msg=$pagetexts['rp_handedness_err'];
            break;
        case 5:
            $msg=$pagetexts['rp_education_err'];
            break;
		case 6:
		    $msg=$pagetexts['rp_ps1_err'];
	    	break;
		case 7:
			$msg=$pagetexts['rp_ps2_err'];
			break;
		case 8:
			$msg=$pagetexts['rp_ps3_err'];
			break;
		case 9:
			$msg=$pagetexts['rp_nation_err'];
			break;
    }*/
	$hand="rp_".$keys[$err]."_err";
	$msg=$pagetexts[$hand];
    $errormsg="<br><div class=\"error\">$msg</div><br><br>";
}

?>
<div id="header"><h1><?php echo $pagetexts['rp_title'];?></h1></div>
<div id="container">
<i id="register_disclaimer">
<?php echo $pagetexts['rp_text'];?>
</i>
<br>
<br>
<?php if(isset($errormsg)) echo $errormsg; ?>
<form method="POST" action="addme.php">
<table id="register">
    <tr class="oddrow">
        <td ><?php echo $pagetexts['rp_sex'];?></td>
        <td>
            <input type="radio" id="idmale" name="sex" value="0" <?php if(isset($_SESSION['sex']) && $_SESSION['sex']==="0"){?>checked="checked"<?php }?> ><label for="idmale"><?php echo $pagetexts['rp_male'];?></label>&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" id="idfemale" name="sex" value="1" <?php if(isset($_SESSION['sex']) && $_SESSION['sex']==="1"){?>checked="checked"<?php }?> ><label for="idfemale"><?php echo $pagetexts['rp_female'];?></label>
        </td>
    </tr>
    <tr class="evenrow">
        <td ><?php echo $pagetexts['rp_age'];?></td>
        <td>
            <select name="age">
            <?php
                for($i=0;$i<100;$i++){
                    $str="";
                    if(isset($_SESSION['age']) && $i==$_SESSION['age']) $str=" SELECTED ";
                    if($i==0 && !isset($_SESSION['age'])) $str=" SELECTED ";
                    echo "<option value=\"$i\"  $str>$i</option>";  
                }
            ?>
            </select>
        </td>
    </tr>
	<tr class="oddrow">
        <td ><?php echo $pagetexts['rp_nation'];?></td>
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
	<tr class="evenrow">
        <td ><?php echo $pagetexts['rp_born'];?></td>
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
    <tr class="oddrow">
        <td ><?php echo $pagetexts['rp_weight'];?></td>
        <td>
            <select name="weight">
            <?php
                for($i=0;$i<200;$i++){
                    $str="";
                    if(isset($_SESSION['weight']) && $i==$_SESSION['weight']) $str=" SELECTED ";
                    if($i==70 && !isset($_SESSION['weight'])) $str=" SELECTED ";
                    echo "<option value=\"$i\"  $str>$i</option>";  
                }
            ?>
            </select> <?php echo $pagetexts['rp_kg'];?>
        </td>
    </tr>
    <tr class="evenrow">
        <td ><?php echo $pagetexts['rp_height'];?></td>
        <td>
            <select name="height">
            <?php
                for($i=0;$i<300;$i++){
                    $str="";
					if(isset($_SESSION['height']) && $i==$_SESSION['height']) $str=" SELECTED ";
                    if($i==170 && !isset($_SESSION['height'])) $str=" SELECTED ";
                    echo "<option value=\"$i\"  $str>$i</option>";  
                }
            ?>
            </select> <?php echo $pagetexts['rp_cm'];?>
        </td>
    </tr>
    <tr class="oddrow">
        <td ><?php echo $pagetexts['rp_handedness'];?></td>
        <td>
            <input type="radio" id="idleft" name="hand" value="0" <?php if(isset($_SESSION['hand']) && $_SESSION['hand']==="0"){?>checked="checked"<?php }?> ><label for="idleft"><?php echo $pagetexts['rp_left'];?></label>&nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" id="idright" name="hand" value="1" <?php if(isset($_SESSION['hand']) && $_SESSION['hand']==="1"){?>checked="checked"<?php }?> ><label for="idright"><?php echo $pagetexts['rp_right'];?></label>
        </td>
    </tr>
    <tr class="evenrow">
        <td ><?php echo $pagetexts['rp_education'];?></td>
        <td>
            <input type="radio" id="idedu1" name="education" value="0" <?php if(isset($_SESSION['education']) && $_SESSION['education']==="0"){?>checked="checked"<?php }?> ><label for="idedu1"><?php echo $pagetexts['rp_edu1'];?></label> &nbsp;&nbsp;&nbsp;
            <input type="radio" id="idedu2" name="education" value="1" <?php if(isset($_SESSION['education']) && $_SESSION['education']==="1"){?>checked="checked"<?php }?> ><label for="idedu2"><?php echo $pagetexts['rp_edu2'];?></label> &nbsp;&nbsp;&nbsp;
            <input type="radio" id="idedu3" name="education" value="2" <?php if(isset($_SESSION['education']) && $_SESSION['education']==="2"){?>checked="checked"<?php }?> ><label for="idedu3"><?php echo $pagetexts['rp_edu3'];?></label>
        </td>
    </tr>
    <tr class="oddrow">
        <td ><?php echo $pagetexts['rp_ps1'];?></td>
        <td>
            <input type="radio" id="idp1n" name="psychologist" value="0" <?php if(isset($_SESSION['psychologist']) && $_SESSION['psychologist']==="0"){?>checked="checked"<?php }?> ><label for="idp1n"><?php echo $pagetexts['rp_n'];?></label>  &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" id="idp1y" name="psychologist" value="1" <?php if(isset($_SESSION['psychologist']) && $_SESSION['psychologist']==="1"){?>checked="checked"<?php }?> ><label for="idp1y"><?php echo $pagetexts['rp_y'];?></label>
        </td>
    </tr>
    <tr class="evenrow">
        <td ><?php echo $pagetexts['rp_ps2'];?></td>
        <td>
            <input type="radio" id="idp2n" name="psychiatrist" value="0" <?php if(isset($_SESSION['psychiatrist']) && $_SESSION['psychiatrist']==="0"){?>checked="checked"<?php }?> ><label for="idp2n"><?php echo $pagetexts['rp_n'];?></label> &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" id="idp2y" name="psychiatrist" value="1" <?php if(isset($_SESSION['psychiatrist']) && $_SESSION['psychiatrist']==="1"){?>checked="checked"<?php }?> ><label for="idp2y"><?php echo $pagetexts['rp_y'];?></label> &nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>
    <tr class="oddrow">
        <td ><?php echo $pagetexts['rp_ps3'];?></td>
        <td>
            <input type="radio" id="idp3n" name="neurologist" value="0" <?php if(isset($_SESSION['neurologist']) && $_SESSION['neurologist']==="0"){?>checked="checked"<?php }?>><label for="idp3n"><?php echo $pagetexts['rp_n'];?></label> &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" id="idp3y" name="neurologist" value="1" <?php if(isset($_SESSION['neurologist']) && $_SESSION['neurologist']==="1"){?>checked="checked"<?php }?>><label for="idp3y"><?php echo $pagetexts['rp_y'];?></label> &nbsp;&nbsp;&nbsp;&nbsp;
        </td>
    </tr>

</table>
<br>
<input type="submit" value="<?php echo $pagetexts['rp_register'];?>" style="width:100%;">
<br>
<br>
<br>
</form>
<?php
include('footer.php');
?>
