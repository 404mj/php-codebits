#! /bin/sh

date

for ((i=0;i<5;i++));do
    {   
        sleep 3; date
    }&
done
wait
