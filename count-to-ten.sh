
num=0
while [ $num  -lt  10  ]
do echo $num
((num++))
done

#can also do this with c++ syntax
#like this ((i=0;i<=10;i++))
#for var declaring in bash remeber that both side should be connected
#like this VAR="this"
