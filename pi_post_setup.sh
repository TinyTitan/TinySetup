#!/usr/bin/env bash

touch ~/mpihostfile

for (( i=1; i<=$1; i++ ))
do
    num=$(($i+100))
    ip=192.168.3.$num
    echo $ip >> ~/mpihostfile
    sudo sh -c "echo \"$ip	pi$i\" >> /etc/hosts"
    sshpass -p 'raspberry' scp -o StrictHostKeyChecking=no pi@pi$i:~/.ssh/id_rsa.pub tmp_key
    cat tmp_key >> ~/.ssh/authorized_keys
done

for (( i=1; i<=$1; i++ ))
do
    sshpass -p 'raspberry' scp -o StrictHostKeyChecking=no ~/.ssh/authorized_keys pi@pi$i:~/.ssh/authorized_keys
done

sudo rm tmp_key
