#!/bin/bash

    $NITABIN/sendlog.bin -type:inf -cat:14 -id:1 -param1:`hostname`
    ssh srv1 shutdown now
    ssh srv2 shutdown now
    ssh azn1 shutdown now
    ssh azn2 shutdown now

if [ $HOSTNAME == "KRP1" ]
then

    ssh krp2 `shutdown now`
    sleep 3s
    shutdown now

else

   ssh krp1 `shutdown now`
   sleep 3s
   shutdown now

fi