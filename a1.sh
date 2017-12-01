#! /bin/bash
echo -n "this file size is :" >> a1.log
du -sh ./a1.sh | awk '{print $1}' >> a1.log
echo -n "this file2 size is :" >> a1.log
du -sh ./a1.sh | awk '{print $1}' >> a1.log
