<pre>
<?php
include('../settings.php');
echo "removing old tar file \n";
echo("rm $path/admin/*.tar");
$ret=system("rm $path/admin/*.tar");
echo $ret;

echo "\n\n making new tar\n\n";

system("$path/admin/tarit.sh $path",$ret);
echo $ret;
echo "\n\n</pre> <a href=\"data/data.tar\">click to download</a>";

