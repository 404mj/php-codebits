<?php
/*$userid = false;
$userid  = intval($userid);
var_export($userid === 0);*/


/*$bacon = base64_encode('59e08e5f1150232b');
var_export(str_split($bacon,3));*/

//var_export(parse_url('https://www.baidu.com/a/b/c/'));

//var_export(mt_rand(1,20));
//var_export(rand(1,20));
//2      1549320803967052        5       3       复兴军事                2       system
/*$fpData = fopen('1.txt', 'r');
$line = trim(fgets($fpData));
var_export($line);
$strArr = explode("\t", $line);
var_export($strArr);*/

//测试一种if/else的写法
//$a = 3;
//($a > 2) ? var_export('hahahh') : false;

/*$warnFlag = array(
    1 => true,
    2 => true,
    3 => true,
);
var_export($warnFlag);*/

//$param = '(paramStr={"company":"\u5317\u4eac\u6781\u7535\u4e07\u76df\u79d1\u6280\u6709\u9650\u516c\u53f8","realchktaskid":"17"}&appId=4)';
//$param2 = 'paramStr%3D%7B%22company%22%3A%22%5Cu5317%5Cu4eac%5Cu6781%5Cu7535%5Cu4e07%5Cu76df%5Cu79d1%5Cu6280%5Cu6709%5Cu9650%5Cu516c%5Cu53f8%22%2C%22realchktaskid%22%3A%2217%22%7D%26appId%3D4';
//var_export(json_encode($param2));
//var_export(json_encode($param));

/*$a = array(
    'status' => 1,
    'errmsg' => '获取数据失败',
);
$b = array(
    'status' => 1,
    'errmsg' => '获取数据失败',
);
var_export($a === $b);*/

//--------------------
//$aaa = false;
//$aaa = null;
//var_export(isset($aaa));
//var_export(isset($aslfhi));

//-----------seperate a array into 2 parts
//$paramArr = array('userType', 'opName', 'officialId', 'infocode', 'fields', 'isAutoSend', array(__CLASS__, 'checkResult'));
//var_export(array_chunk($paramArr, 6)); // 一种方式
//var_export(implode(',', $paramArr));  // 把array编程字符串
//var_export(array_chunk($paramArr, ceil(count($paramArr) / 2)));
//var_export(array_slice($paramArr, 0,6));

//---------------------------------
//$taskRes = array (
//    'status' => 3,
//    'errmsg' => '获取官方数据为空',
//);
//$taskRes = array($taskRes);
//var_export(json_encode($par));exit;
//
//
//$param1 = '[{"status":3,"errmsg":"\u83b7\u53d6\u5b98\u65b9\u6570\u636e\u4e3a\u7a7a"}]';
//$param12 = '{"status":3,"errmsg":"\u83b7\u53d6\u5b98\u65b9\u6570\u636e\u4e3a\u7a7a"}';
//var_export(json_decode($param1, true));
//echo "\n";
//var_export(json_decode($param12, true));exit;
//$param = '[1,"v_zhangshuxin01",19999999,"91110116MA00GAB87D",{"idType":1,"vType":10,"company":"\u5317\u4eac\u8fea\u65e5\u77f3\u6cb9\u5316\u5de5\u6709\u9650\u516c\u53f8","describe":"\u5317\u4eac\u8fea\u65e5\u77f3\u6cb9\u5316\u5de5\u6709\u9650\u516c\u53f8"},false]';
//$sobj = 'a:2:{i:0;O:14:"Logic_CustShow":0:{}i:1;s:13:"showDataAsync";}';
//$sobj1 = 'a:2:{i:0;O:14:"Logic_CustShow":0:{}i:1;s:11:"checkResult";}';
//require_once('/home/users/v_zhangshuxin01/defensor/thrones/scripts/../scripts/auth/task.php');
//var_export(unserialize($sobj));
//echo "\n";
//var_export(unserialize($sobj1));
//$res = call_user_func_array(unserialize($sobj1), json_decode($param1, true));
//$res = call_user_func_array(unserialize($sobj1), array($param1));

//var_export($res);

//-----------------------------
$checkRes = true;
if (is_bool($checkRes)) {
    // 处理bool返回类型
    $flag =  $checkRes ? 111 : 222;
}
var_export($flag);




