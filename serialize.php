<?php 

class One {

    public $one = 1;

    public function __construct() {
      $one = 2;
    }

    public function show() {
        echo $this->one;
    }
}


$one = new One();
$one2 = new One();

//var_export(file_get_contents('http://www.baidu.com'));
file_put_contents('class_one', serialize($one));
file_put_contents('class_one', serialize($one2),FILE_APPEND);

$get = file_get_contents('class_one');

$getone = unserialize($get);
$getone2 = unserialize($get);


$getone->show();
$getone2->show();

