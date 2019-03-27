<?php
    include_once('temp/embody/v1/lib.php');
    include_once('settings_paint.php');
    include_once('temp/embody/v1/headerpaint.php');
    
    $stimuli=loadTxt($stimulusfile,0);
    
    $userID=$_GET['userID'];
    $p=$_GET['presentation'];
	$currbatchID=$_GET['currbatchID'];
    $progress = $_GET['perc'];
    //middle part of the image
    
    // $p is the ID of the word to show
    $outfile="./subjects/$userID/$p"."_$currbatchID".".csv";
    $perc=$_GET['perc'];
    ?>


<div id ="header">
<span style="font-size:14px;font-weight:bold;margin-left:10px;position:absolute;">id: <?php echo $userID; ?></span>
<div style="float:right;margin-right:10px;"><a href="help.php" target="_blank"><img src="images/help-button.png" width="20" height="20" alt="help"></a></div>

<div id="progress-bar" class="all-rounded">
<div id="progress-bar-percentage" class="all-rounded" style="width: <?php echo $perc;?>%"><span><?php echo $perc;?>%</span>
</div>
</div>


</div>

<div id="container">

<div style="bottom:0px;left:0px;">
<span></span><span>&nbsp;</span>
</div>

<!---instructions in the middle-->
<div style="text-align:center;margin-top:50px;">
<div id = "pboxL"><h3 style="font-weight:bold;"><br>
<?php echo $tasklabel;?></h3> </div>

<?php if($type == 'paintimages'){
    if(file_exists($stimuli[$p])):
        $stimulusimage = $stimuli[$p];
    else:
        $stimulusimage = './yuno.jpg';
    endif;
    ?>
<img style="width:480px;margin-top:10px;border:2px solid black;" src="<?php echo $stimulusimage;?>">
</div>
<?php }elseif($type == 'paintwords'){?>
<div class="wordsbox"> 
Ajattele seuraavaksi tuntemusta tai olotilaa
<br><br><br>
<br><br>
<h1>
<?php echo $stimuli[$p];?>
</h1>
<br><br>
<br><br>
Ja väritä viereisestä kehosta alueet joissa koet sen tuntuvan
</div>
</div>
<?php }?>

<div id="pbox">
    <div id="pbox1">
    </div>
    <div id="pbox1L">
<?php echo $labels[0]; ?>
    </div>

    <div id="pbox2">
    </div>
    <div id="pbox2L">
<?php echo $labels[1]; ?>
    </div>
    </div>

<!--- navigation -->

</div>

<script type="text/javascript">
        var temp=document.getElementById("pbox");
        temp.onselectstart = function() { this.style.cursor='crosshair'; return false; }
</script>


<div id = "footer">

<form method="POST" action="getit.php" id="movenext">
<input type="hidden" name="currbatchID" value="<?php echo $currbatchID;?>">
<input type="hidden" name="presentation" value="<?php echo $p;?>">
<div style="float:right;margin-right:10px;margin-top:10px;">
<input type="submit" value="<?php echo $pagetexts['forward'];?>" style="color:#093;cursor:pointer;background:#ddd;font-size:20px;padding:1px;font-weight:bold;"></div></form>

<form action="#"><input type="button" style="color:#f00;cursor:pointer;background:#ddd;font-size:20px;padding:1px;font-weight:bold;margin-top:10px;margin-left:10px;" value=<?php echo $pagetexts['delete'];?>  onClick="history.go()"></form>

<script type="text/javascript" >

$(window).bind('resize', function(e)
{
  if (window.RT) clearTimeout(window.RT);
  window.RT = setTimeout(function()
  {
    this.location.reload(false); /* false to get page from cache */
  }, 100);
});


// $("span:first").text('ac '+spraycan);
var currbatchID="<?php echo $currbatchID;?>";
var presentation="<?php echo $p;?>";
var outfile="<?php echo $outfile; ?>";
var xp=$("#pbox").offset().left;
var yp=$("#pbox").offset().top;
var arrX = new Array(0);
var arrY = new Array(0);
var arrTime = new Array(0);

var arrXD = new Array(0);
var arrYD = new Array(0);
var arrTimeD = new Array(0);

var arrMD = new Array(0);
var arrMU = new Array(0);

spraycan();
$("#pbox").mousemove(function(e){
                     var x= e.pageX - xp;
                     var y = e.pageY - yp;
                     var colid=Math.floor((x/10)%10);
                     if(x<450)
                     spraycan.currColour = 'ff0000';
                     else
                     spraycan.currColour = '0000ff';
                     
                     arrX.push(x);
                     arrY.push(y);
                     arrTime.push(e.timeStamp);
                     
                     // debug stuff
                     /*
                      var pageCoords = "( " + arrXD[arrXD.length-1] + ", " + x + " )";
                      $("span:first").text("( xD, x ) - " + pageCoords);
                      $("span:last").text("( e.timeStamp ) - " + e.timeStamp);
                      */
                     //}).mousedown(function(e){
                     //  arrMD.push(e.timeStamp);
                     //
                     //}).mouseup(function(e){
                     //  arrMU.push(e.timeStamp);
                     
                     });


/* attach a submit handler to the form */
$("#movenext").submit(function(event) {
                      /* stop form from submitting normally */
                      event.preventDefault();
                      
                      /* get some values from elements on the page: */
                      var $form = $( this );
                      url = $form.attr( 'action' );
                      
                      /* Send the data using post and put the results in a div */
                      $.post( url, {'arrX': arrX, 'arrY': arrY, 'arrTime': arrTime,'arrXD': arrXD, 'arrYD': arrYD, 'arrTimeD': arrTimeD, 'arrMU': arrMU, 'arrMD': arrMD, 'file': outfile, 'currbatchID': currbatchID, 'presentation': presentation },
                             function(data) {
                             if(data==1)
                             window.location = "session_batch.php?auto=1&userID=<?php echo $userID; ?>&currbatchID=<?php echo $currbatchID;?>";
                             else
                             window.location = "error.html";
                             }
                             );
                      });

</script>

<?php
    include('footer.php');
    ?>
