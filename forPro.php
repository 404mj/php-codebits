<?php
   //第2题：
    $arr = array(1, 2, 3);
    foreach($arr as &$v) {
        //nothing todo.
    }
//    var_export($arr);
    foreach($arr as $v) {
        //nothing todo.
    }
  //  var_export($arr);
    //output:array(0=>1,1=>2,2=>2)，你的答案对了吗？为什么

    $arr2 = array(1,2,3,4);
    foreach($arr2 as $val) {
        
    }
    var_export($val);



?>
