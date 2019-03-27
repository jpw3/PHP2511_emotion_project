<?php



echo "var slider=new Array();\n";
for($i=0;$i<50;$i++)
{
echo "slider[$i]=new Object();\n";
echo "slider[$i].min=0;\n";
echo "slider[$i].max=10;\n";
echo "slider[$i].val=5;\n";
echo "slider[$i].onchange=setBoxValue;\n";
}
?>
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
function setBoxValue(val, box) {
    var b=document.getElementById('output'+box);
        val=Math.round(val*1000)/1000;
        b.value=val;
}
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */


