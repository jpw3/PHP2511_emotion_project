/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
var slider=new Array();
slider[1]=new Object();
slider[1].min=0;
slider[1].max=10;
slider[1].val=5;
slider[1].onchange=setBoxValue;

slider[2]=new Object();
slider[2].min=0;
slider[2].max=10;
slider[2].val=5;
slider[2].onchange=setBoxValue;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
function setBoxValue(val, box) {
    var b=document.getElementById('output'+box);
	val=Math.round(val*1000)/1000;
	b.value=val;
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

