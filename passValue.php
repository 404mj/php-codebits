<?php
/***************************************************************************
 * 
 * Copyright (c) 2017 Baidu.com, Inc. All Rights Reserved
 * 
 **************************************************************************/
 
 
 
/**
 * @file passValue.php
 * @author v_zhangshuxin01(com@baidu.com)
 * @date 2017/06/01 15:39:33
 * @brief 
 *  
 **/


function changeValue($a) {
    $a = 5;
    echo $a . "\n";
}

$a = 1;
changeValue($a);
echo "===========调用结束 \n";
echo $a;


/* vim: set expandtab ts=4 sw=4 sts=4 tw=100: */
?>
