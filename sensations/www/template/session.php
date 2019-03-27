<?php
include_once('settings.php');
include_once('lib.php');
    
    $users=array();
    $subjDir=opendir('./subjects/');

    while (false !== ($f = readdir($subjDir))) {
        if($f == "." || $f == "..")
            continue;
        array_push($users,$f);
    }
    closedir($subjDir);
    $userID=$_GET['userID'];
    $helpful=array('user'=>"$userID");

//test for userID validity

    if($userID == ""){
        header("Location: index.php");
    }
    
    $found=0;
    foreach($users as $user){
        if($userID == $user)
            $found = 1;
    }
    
    if($found==0){    
		include('header.php');
        die(insertVarValues($pagetexts['uid_error'],$helpful));
    }
    
// WE HAVE THE SUBJECT, LET'S START THE SESSION

    // does the subject already have a presentation file?
    $pfpath='./subjects/'.$userID.'/presentation.txt';
	$folderpath='./subjects/'.$userID;
    
    // if the file is missing generate it
    if(!(is_file($pfpath)))
    {
        makePresentation($pfpath,$folderpath);
    } 
    
    // load the presentation 
    $presentation=loadTxt($pfpath,0);
    
    // see how much has been done
    $done=0;
    $annpath='./subjects/'.$userID.'/';
    foreach($presentation as $p)
    {
        if(is_file($annpath.trim($p).".csv"))
        {
            $done++;
        }
    }
    
    $amount=$done/(count($presentation));
    $amount=floor($amount*10000)/10000; // round to two points after percent decimal
    $perc=100*$amount;
    
    //start adding contents
    $outtext='';
    $outtext.="<div id='header'>";
    $outtext.="<div id=\"headeralways\">".$pagetexts['sub_ID']." <span style=\"color:red;font-weight:bold;\">".$userID."</span><span style=\"margin-left:50px;\">".$pagetexts['done_perc']." ".$perc."%</span></div>";
 //   $outtext.="<div id='progress-bar' class='all-rounded' style=\"float:right\"> <div id='progress-bar-percentage' class='all-rounded' style='font-size:14px;font-weight:bold;margin-left:100px;position:absolute'> <span>".$pagetexts['done_perc'].$perc."%<br></span>";
    //$outtext.="</div></div></div><div id='container'>";
    $outtext.="</div><div id='container'>";

    
    if($amount == 1){
		/*if(!is_file($folderpath.'/animal_experiences.csv'))
			header("Location: ./afterquestions.php?userID=$userID");
		elseif(!is_file($folderpath.'/traumatic_experiences.txt'))
			header("Location:./experiences.php?userID=$userID");
		else{*/
        $outtext.="<br><h1>".$pagetexts['thank-you']."</h1><br><br><br><div style=\"width:400px;text-align:center;margin-left:auto;margin-right:auto\"><a class=\"bottone\" href=\"http://emotion.nbe.aalto.fi/site/index.php/participate/\">Participate to other online studies</a></div>";
		//$outtext.="<img src = 'img/kitten.jpg' style='align:center; width:960px; height:600px;' alt='Meeeeow'>";
        //$outtext.=insertVarValues($pagetexts['done'], $helpful);
		
    }else{
        //pick out header from pagetexts-file
        $outtext.="<br><h1>".$pagetexts['rating_title']."</h1>";
        $helpful['percentage'] = $perc;
    if($amount < 1)
    {
        
        //if there is a specified welcome file, take that
        if(isset($welcome)) {
                $welcome=loadTxt($welcomefile,0);
        }
        $outtext.="<h2>".$pagetexts['instr_title']."</h2>";
        
        //add instructions from file
        if(isset($instructions)) {
            $outtext.=$instructions;

        }
	
        
        $presentation=$presentation[$done];

        if (in_array($type, $allowedTypes)){
            $link = $type;
        } else {
            die("variable $type missing from settings.php");
        }

        if ($type=="form"):
            $goto="myvas.php?perc=$perc&userID=$userID&presentation=$presentation";
        else:
            $goto=$link."annotate.php?perc=$perc&userID=$userID&presentation=$presentation";
        endif;
        $helpful['goto'] = $goto;
        $outtext.="<br><div style=\"margin-left:auto;margin-right:auto;text-align:center;width:100%;\"><a href=\"".$goto."\" class=\"bottone\">".$pagetexts['start_ratings']."</a><br></div>";
		//$outtext.="<img src = 'images/example.jpg' style='margin:auto; width:750px; height:600px;' alt=\"Example\"><br><br>";
    }
    }
$auto="";
if(array_key_exists('auto',$_GET))
	$auto=$_GET['auto'];
if($auto==1 && $amount!=1){
    header("Location: $goto");
    //echo "auto";
}
else
{
    include('header.php');
    echo $outtext;
    include('footer.php');
}

?>
