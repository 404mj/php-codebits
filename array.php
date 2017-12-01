<?php
/***************************************************************************
 * 
 * Copyright (c) 2017 Baidu.com, Inc. All Rights Reserved
 * 
 **************************************************************************/
 
 
 
/**
 * @file array.php
 * @author v_zhangshuxin01(com@baidu.com)
 * @date 2017/06/01 14:36:22
 * @brief 
 *  
 **/

$a = array(
    1 => '这是一',
    2 => '这是二',
    3 => '这是三'
    );

$b = array(
    '1' => '兼职1',
    '2' => '兼职2',
    '3' => '兼职3'
    );

$c = array('无序号1', '无序号2', '无序号3');

$e = array(1,2,3);
$e[] = 4;
$e[] = 5;
//var_dump($e);
//$d = ['shuzu1', 'shuzu2', 'shuzu3'];

//var_dump($a);
echo $a[1] . '<br/>';
echo $a['1'] . '<br/>';
echo $a[0];
echo '--------------------' . PHP_EOF;
//var_dump($b);

echo '--------------------' . PHP_EOF;
//var_dump($c);
echo $c[0];




/* vim: set expandtab ts=4 sw=4 sts=4 tw=100: */
?>
