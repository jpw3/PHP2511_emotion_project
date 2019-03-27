<?php
include_once('settings.php');
include_once('lib.php');
    $userID=$_GET['userID'];
    $presentation=$_GET['presentation'];
    $perc=$_GET['perc'];
include('header_sim.php');


?>

<?php echo "<div id=\"headeralways\"><div style='float:right;margin-right:20px;margin-left:20px;font-size:11px;text-align:center;border:1px dashed white;'>".$pagetexts['sub_ID']."<br><span style=\"color:#fc0;font-weight:bold;\">".$userID."</span> <a href=\"ohjeet.php\" target=\"_blank\"><img  src=\"img/help-button.png\" width=\"10\" height=\"10\" alt=\"help\" title=\"help!\"></a></div>
<div style = \"text-align:left;font-size:11px;\">";
echo $pagetexts['vas_instructions']; ?>
</div>
</div>

<div id="container">

    <canvas id="canvas" width="1000" height="600"></canvas>
<div style="position:absolute;width:600px;height:602px;border:1px solid black;top:49px;margin-left:401px;z-index:-1000;"></div></div>
<form method="POST" action="getit.php" id="movenext">
<input type="submit" value="<?php echo $pagetexts['forward'];?>" style="color:#093;cursor:pointer;background:#ddd;font-size:20px;padding:1px;font-weight:bold;" id="simbutton">

</form>

<script>
$(window).bind('resize', function(e)
{
  if (window.RT) clearTimeout(window.RT);
  window.RT = setTimeout(function()
  {
    this.location.reload(false); /* false to get page from cache */
  }, 100);
});

//texts=1;

var d = new Date();
var starttime = d.getTime(); 

    $("#movenext").submit(function(event) {
                      /* stop form from submitting normally */
                      event.preventDefault();
                      
                      /* get some values from elements on the page: */
                      var $form = $( this );
                      url = $form.attr( 'action' );
                      
						var d = new Date();
						var now = d.getTime();
						var nowSecs=Math.floor(now/1000); // seconds are enough
                      /* Send the data using post and put the results in a div */
                      $.post( url, {'userID': userID, 'timestamp': nowSecs, 'locations': locations },
                             function(data) {
                             if(data==1)
                             window.location = "finalize.php?userID=<?php echo $userID;?>";
                             else
                             window.location = "error.html";
                             }
                             );
                      });


var refreshIntervalId=setInterval(sendThem,15000); // every 10 seconds
function sendThem(){
	var d = new Date();
	var now = d.getTime();
	var nowSecs=Math.floor(now/1000); // seconds are enough
	$.ajax({
        type: "POST",
        url: "getit.php",
        data: {
			'userID': userID,
            'locations': locations,
			'timestamp': nowSecs
        },
		success: function(response){if(response != 1) window.location = "error.html"; }
    });
	console.log(now);
	if(now>starttime+1800*1000){ clearInterval(refreshIntervalId); //  1800 seconds session i.e. 30 mins
		window.location.replace("session_expired.php?userID=<?php echo $userID;?>");
	} // 100 seconds for now
}
</script>

</body>
</html>
