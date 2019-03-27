<?php
include_once('lib.php');
//this is the only part you should need to change when setting up a new experiment. Also, read the readme.txt to figure out which textfiles you need to put in $path location.
    
    $allowedTypes = array("form", "video", "paintwords", "paintimages", "paintaudio");
        //possible types at this moment are : form, video annotator, painting with words, painting with images, painting with audiofile
    $type =         'form';       // $type has to be one of the $allowedTypes (remember quotes)
    $language =     'FI';                 // two-letter language code, will be added to end of file names to get texts in correct language. If study is only in one language, you can leave this to ''
    $countryID = 160; // number for the preselected language and nationality
	$instrfile =    'instructions.txt';  // displayed after login, before stimuli
    $stimuli =      'sensations_FI.txt';        // stimuli to be displayed
    $pgtexts =      'page_texts_FI.csv';   // bits and bobs of text peppered around the system, see example page_texts.txt for explanation what should be found there
    $path="/var/www/emotion.becs.aalto.fi/sensations_FI/";
	$wwwlocation = 'http://emotion.nbe.aalto.fi/sensations_FI/';
// If you're not doing anything funky, you shouldn't need to change anything after this.
//these are common for all cases

    if (file_exists($instrfile)){
        $instructions=file_get_contents($instrfile);
    }
	else{
        $instructions = "There are no instructions defined.";
    }


    $stimulusfile = $stimuli;
    $stimuliArray = loadTxt($path.$stimulusfile,0);
	$Nstimuli=count(loadTxt($path.$stimulusfile,0)); // number of stimuli
    $pagetextfile = $pgtexts;
    if (file_exists($pagetextfile)){
        $pagetexts=loadPgTxt($pagetextfile,0); //this has all those little words that there are on the front page
    }else{
        $pagetexts = array(0 => "There are no page texts defined");
    }
    $title      =   "";
    $tasklabel  =   "";

switch($type){
    case "form":
        // if form then we need a list of sentences
        break;
    case "video":
        // if video we need a list of videofiles and ..
        break;
    case "paintwords":
        //if paintwords we need a file with all the words
	    $labels=array('V&auml;rit&auml; t&auml;st&auml; kehosta alueet joiden toiminnan koet on voimistuvan tai kiihtyv&auml;n','V&auml;rit&auml; t&auml;st&auml; kehosta alueet joiden toiminnan koet heikkenev&auml;n tai hidastuvan');
        break;
    case "paintimages":
        //if paintimages we need a folder with all the images
        $stimulusfile="EmotionPictures";
        $labels=array('V&auml;rit&auml; t&auml;st&auml; kehosta alueet joiden toiminnan koet on voimistuvan tai kiihtyv&auml;n','V&auml;rit&auml; t&auml;st&auml; kehosta alueet joiden toiminnan koet heikkenev&auml;n tai hidastuvan');
        break;

}

?>
