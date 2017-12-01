<?php
class DefaultParam {
    public function testP($a=1, $b= 2, $c =3, $d = 4, $e = 5) {
        echo $c;
        echo "\n";
        echo $e;
    }

}

$zzz = new DefaultParam();
$zzz->testP(1,2,$e=6);

