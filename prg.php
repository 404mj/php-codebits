<?php
$url1 = 'https://www.qaz.net/1/2/3?sdfd';
$url2 = 'http://www.qaz.net';
$url3 = 'www.baidu.com/ere/sdfds';
$url4 = 'www.baidu.com?name=a';

$prg1 = '/^([https|http]:\/\/)(\w+\.{2}\w+)(\/.?)/i';
$prg2 = '/^(https?:\/\/)?([^\/:?]+)/i';


preg_match($prg2,$url1,$matches);
$url2 =  preg_replace($prg2,'$2',$url1);
var_dump($matches);

//var_dump($matches);

?>
