#!/bin/bash
a=helle
b=world
line=$(wc -l pull.log | awk '{print $1}')
if [ $line -eq 0 ]; then
    # 记录缺失日志，
    echo ${a} ${b}
fi
i_date=20170401
hdplog=ecom-darwin-vcard_$(date -d '+1 day'$i_date +'%Y%m%d')_
echo $hdplog
c=$(ls | grep ${hdplog})
if [ $? -eq 0  ]; then
    echo $c
fi

a=1.log
cat $a

