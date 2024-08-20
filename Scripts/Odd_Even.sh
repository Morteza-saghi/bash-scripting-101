#!/bin/bash
read -p "give me num " num1

if [ $((num1 % 2 )) -gt 0  ]
then echo "this num is odd"

else echo "this num is even"
fi
