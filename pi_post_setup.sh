#!/usr/bin/env bash

echo "Enter the total number of Pi nodes in the cluster followed by [ENTER]: "
read num_pis
re='^[0-9]+$'
if ! [[ $num_pis =~ $re ]] ; then
    echo "Error: Please enter integer" >&2; exit 1
fi

echo "Removing ~/mpihostsfile"
rm -f ~/mpihostsfile
echo "Removing ~/.ssh/authorized_keys"
rm -f ~/.ssh/id_rsa.pub

echo "Generating ~/mpihostsfile"
echo "Generating ~/.ssh/authorized_keys"
echo "Updating /etc/hosts"

sudo sed -i '/192.168.3.*/d' /etc/hosts

for (( i=1; i<=$num_pis; i++ ))
do
    num=$(($i+100))
    ip=192.168.3.$num
    echo $ip >> ~/mpihostsfile
    sudo sh -c "echo \"$ip	pi$i\" >> /etc/hosts"
    sshpass -p 'raspberry' scp -o StrictHostKeyChecking=no pi@pi$i:~/.ssh/id_rsa.pub tmp_key
    cat tmp_key >> ~/.ssh/authorized_keys
done

for (( i=1; i<=$num_pis; i++ ))
do
    sshpass -p 'raspberry' scp -o StrictHostKeyChecking=no ~/.ssh/authorized_keys pi@pi$i:~/.ssh/authorized_keys
done

sudo rm tmp_key
