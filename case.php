<?php 
    $rejNums = 8;
    
    $colZero     = 0;
    $colOne      = 0;
    $colTwo      = 0;
    $colThree    = 0;
    
    switch ($rejNums) {
        case 1:
            $colOne   = 1;
            break;
        case 2:
            $colTwo   = 1;
            break;
        case 3:
        default:
            $colThree = 1;
    }

var_export(array($colZero,$colOne, $colTwo,$colThree));
