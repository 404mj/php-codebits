<?php

$jsonStr = '{"appid":1028,"authid":14,"userid":20864192,"orderid":24488,"authuniqid":"1493708057076807"}';

$arr = Array(
        'a' => 111,
        'b' => 222,
        'c' => 333,
        );

$a = json_decode($jsonStr, true);
$b = json_decode($jsonStr);
$c = json_encode($jsonStr);

$d = json_encode($arr);
$e = json_decode($d);

//print_r($a);
//var_export($a);
//print_r($a['appid']);
//print_r($a);
//print_r($b);
//print_r($c);
print_r($e);
echo $e['a'];//会Fatal error
