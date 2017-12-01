<?php 

$res = array(
        'status' => '',
        'data'   => array(
                'licence' => '',
                'regCap'  => '',
                //'customer' => array(
                  //      'zhangsan' => '',
                    //    'lisi' => ''
                   // ),
            ),
        );

var_export($res);
var_export(empty($res));

echo "\n";
//$res = array_values($res['data']);

//var_export($res);

//var_export(empty($res[0]));

var_export(array_count_values($res['data']));

