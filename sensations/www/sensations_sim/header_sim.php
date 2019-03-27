<!doctype html>
<html>
	<head>
		<title><?php echo $pagetexts['title']; ?></title>
		<LINK href="css/sim.css" rel="stylesheet" type="text/css">
		<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
<meta name="google" value="notranslate">


<!-- <script type="text/javascript" src="http://code.jquery.com/jquery.js"></script> -->
<script type="text/javascript" src="jquery.js"></script>
<style>
    #theText{width:10em;}
</style>
<script>
  // an array to hold text objects
    var texts=[];
	// generate words array
	<?php
		echo "var words = [";
		$temp=implode('","',$stimuliArray);
		$temp=str_replace('LISTOFSENSATIONS",','',$temp);
		echo $temp;
		echo '"];';
		echo "\n";
		// load last locations
		$outdatafile=$path."subjects/".$userID."/outdata.csv";
		$temp=loadTxt($outdatafile,0);
		$outdata_last=array_pop($temp);
		$outdata=explode(",",$outdata_last);
		echo "var locations = [";
		for($n=0;$n<200;$n++){
			$locations[$n]=$outdata[$n];
		}
		$locationsstr=implode(",",$locations);
		echo $locationsstr;
		echo '];';
	?>


	<?php
		echo 'var userID = "';
		echo $userID.'";';
	?>

$(function(){

    // canvas related variables
    var canvas=document.getElementById("canvas");
    var ctx=canvas.getContext("2d");
	

    // variables used to get mouse position on the canvas
    var $canvas=$("#canvas");
    var canvasOffset=$canvas.offset();
    var offsetX=canvasOffset.left;
    var offsetY=canvasOffset.top;
    var scrollX=$canvas.scrollLeft();
    var scrollY=$canvas.scrollTop();

    // variables to save last mouse position
    // used to see how far the user dragged the mouse
    // and then move the text by that distance
    var startX;
    var startY;

  

    // this var will hold the index of the hit-selected text
    var selectedText=-1;

    // clear the canvas & redraw all texts
    function draw(){
        ctx.clearRect(0,0,canvas.width,canvas.height);
        for(var i=0;i<texts.length;i++){
            var text=texts[i];
            ctx.fillText(text.text,text.x,text.y);
        }
    }

    // test if x,y is inside the bounding box of texts[textIndex]
    function textHittest(x,y,textIndex){
        var text=texts[textIndex];
        return(x>=text.x && 
            x<=text.x+text.width &&
            y>=text.y-text.height && 
            y<=text.y);
    }

    // handle mousedown events
    // iterate through texts[] and see if the user
    // mousedown'ed on one of them
    // If yes, set the selectedText to the index of that text
    function handleMouseDown(e){
      e.preventDefault();
      startX=parseInt(e.clientX-offsetX);
      startY=parseInt(e.clientY-offsetY);
      // Put your mousedown stuff here
      for(var i=0;i<texts.length;i++){
          if(textHittest(startX,startY,i)){
              selectedText=i;
          }
      }
		var text=texts[selectedText];
		ctx.font="20px";
		draw();
    }

    // done dragging
    function handleMouseUp(e){
      e.preventDefault();
      selectedText=-1;
    }

    // also done dragging
    function handleMouseOut(e){
      e.preventDefault();
      selectedText=-1;
    }

    // handle mousemove events
    // calc how far the mouse has been dragged since
    // the last mousemove event and move the selected text
    // by that distance
    function handleMouseMove(e){
      if(selectedText<0){return;}
      e.preventDefault();
      mouseX=parseInt(e.clientX-offsetX);
      mouseY=parseInt(e.clientY-offsetY);

      // Put your mousemove stuff here
      var dx=mouseX-startX;
      var dy=mouseY-startY;
      startX=mouseX;
      startY=mouseY;

      var text=texts[selectedText];
      text.x+=dx;
      text.y+=dy;
	 locations[2*selectedText]=text.x;
	 locations[2*selectedText+1]=text.y;
      draw();
    }
	
	/*function handleMouseOver(e){
		if(selectedText<0){return;}
		var text=texts[selectedText];
		text.font="20px";
		draw();
	}*/
    // listen for mouse events
    $("#canvas").mousedown(function(e){handleMouseDown(e);});
    $("#canvas").mousemove(function(e){handleMouseMove(e);});
    $("#canvas").mouseup(function(e){handleMouseUp(e);});
    $("#canvas").mouseout(function(e){handleMouseOut(e);});
	//$("#canvas").mouseover(function(e){handleMouseOver(e);});
    $("#submit").click(function(){

        // calc the y coordinate for this text on the canvas
        var y=texts.length*20+20;

        // get the text from the input element
        var text={text:$("#theText").val(),x:20,y:y};

        // calc the size of this text for hit-testing purposes
        ctx.font="16px verdana";
        text.width=ctx.measureText(text.text).width;
        text.height=16;

        // put this new text in the texts array
        texts.push(text);
	


        // redraw everything
        draw();

    });

	

	$(document).ready(function(){
		ctx.rect(200,200,100,100);
		ctx.lineWidth = 7;
		ctx.strokeStyle = 'black';
		ctx.stroke();
		for(i=0;i < words.length; i++){
			//var x = Math.floor((Math.random() * 10))*20 + 200;
			//var y = Math.floor((Math.random() * 80))*5 + 150;
			var x = locations[2*i];
			var y = locations[2*i+1];
			var thisword=words[i];
			var text={text:thisword,x:x,y:y};
			ctx.font="11px sans-serif";
			ctx.fillStyle="black";
			text.width=ctx.measureText(text.text).width;
			text.height=16;
			texts.push(text);
			draw();
		}
	});

}); // end $(function(){});

</script>


	</head>
		<body>
