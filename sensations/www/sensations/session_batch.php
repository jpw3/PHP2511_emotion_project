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
	/////$currbatchF='./subjects/'.$userID.'/currbatch.txt';
    $pfpath='./subjects/'.$userID.'/presentation_1.csv';
	$seqpath='./sequences/';
	$folderpath='./subjects/'.$userID;
    
    // if the file is missing generate it
    if(!(is_file($pfpath)))
    {
        makePresentation_seq($seqpath,$folderpath,$userID,5);
    } 
    
	// load the batch
	$currbatchpath=$folderpath.'/currbatch.csv';
	$currbatchID=loadTxt($currbatchpath,0);
	$currbatchID=$currbatchID[0];
	$increasebatch="";
	if(array_key_exists('increasebatch',$_GET))
		$increasebatch=$_GET['increasebatch'];

	if($increasebatch=="1")
	{
		$currbatchID=$currbatchID+1;
			$cbfh=fopen($currbatchpath,'w');
			fwrite($cbfh,"$currbatchID\n");
			fclose($cbfh);
	}

	$pfpath='./subjects/'.$userID.'/presentation_'.$currbatchID.'.csv';
    // load the correspnding presentation 
    $currbatch=loadTxt($pfpath,0);
    // see how much has been done for each batch
	for($batch=1;$batch<=5;$batch++)
	{
		$done=0;
		$annpath='./subjects/'.$userID.'/';
		$batch_presentation=loadTxt('./subjects/'.$userID.'/presentation_'.$batch.'.csv',0);
		foreach($batch_presentation as $p)
		{
			if(is_file($annpath.trim($p)."_$batch.csv"))
			{
				$done++;
			}
		}
    
		$amount[$batch]=$done/(count($batch_presentation));
	
		if($amount[$batch]<1 && $currbatchID==$batch)
		{	
			//$currbatchID=$batch;
			$currdone=$done;
			//$currbatch=$batch_presentation;
		}
	}
	

		$amount[$currbatchID]=floor($amount[$currbatchID]*10000)/10000; // round to two points after percent decimal
		$perc=100*$amount[$currbatchID];
		
    //start adding contents
    $outtext='';
    $outtext.="<div id='header'>";
    $outtext.="<div id=\"headeralways\">".$pagetexts['sub_ID']." <span style=\"color:#fc0;font-weight:bold;\">".$userID."</span> <span style=\"margin-left:50px;\">".$pagetexts['done_perc']." ".$perc."% <span style=\"color:#093;\">$currbatchID</span></span></div>";
 //   $outtext.="<div id='progress-bar' class='all-rounded' style=\"float:right\"> <div id='progress-bar-percentage' class='all-rounded' style='font-size:14px;font-weight:bold;margin-left:100px;position:absolute'> <span>".$pagetexts['done_perc'].$perc."%<br></span>";
    //$outtext.="</div></div></div><div id='container'>";
    $outtext.="</div><div id='container'>";

    
    if($amount[$currbatchID] == 1){ // if first  batch is completed
		/*if(!is_file($folderpath.'/animal_experiences.csv'))
			header("Location: ./afterquestions.php?userID=$userID");
		elseif(!is_file($folderpath.'/traumatic_experiences.txt'))
			header("Location:./experiences.php?userID=$userID");
		else{*/
		$somemore="";
		if($currbatchID<5) {
			$somemore=$pagetexts['moremore']."<br><br><a class=\"bottone\" href=\"session_batch.php?userID=$userID&auto=1&increasebatch=1\">".$pagetexts['yesyes']."</a><br><br>".$pagetexts['oror']."<br><br>";
		}

        $outtext.="<br><h1>".$pagetexts['thank-you']."</h1><br><br><br><div style=\"width:400px;text-align:center;margin-left:auto;margin-right:auto\">$somemore<a class=\"bottone\" href=\"http://emotion.nbe.aalto.fi/site/index.php/participate/\">".$pagetexts['participate']."</a></div>";
		// add an if


		//$outtext.="<img src = 'img/kitten.jpg' style='align:center; width:960px; height:600px;' alt='Meeeeow'>";
        //$outtext.=insertVarValues($pagetexts['done'], $helpful);
		
    }else{
        //pick out header from pagetexts-file
        $outtext.="<br><h1>".$pagetexts['rating_title']."</h1>";
        $helpful['percentage'] = $perc;
    if($amount[$currbatchID] < 1)
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
	
        
        $presentation=$currbatch[$currdone];

        if (in_array($type, $allowedTypes)){
            $link = $type;
        } else {
            die("variable $type missing from settings.php");
        }

        if ($type=="form"):
            $goto="myvas.php?perc=$perc&userID=$userID&presentation=$presentation&currbatchID=$currbatchID";
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
if($auto==1 && $amount[$currbatchID]!=1){
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
