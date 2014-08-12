#!/usr/bin/env bash

#The MIT License (MIT)

#Copyright (c) 2014 Oak Ridge National Laboratory

#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:

#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.

#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.


echo "Enter the total number of Pi nodes in the cluster followed by [ENTER]: "
read num_pis
re='^[0-9]+$'
if ! [[ $num_pis =~ $re ]] ; then
    echo "Error: Please enter integer" >&2; exit 1
fi

echo "Removing ~/mpihostsfile"
rm -f ~/mpihostsfile
echo "Removing ~/.ssh/authorized_keys"
rm -f ~/.ssh/authorized_keys

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
