
clear
for i in {1..100}
do
echo $i
done



# in the in the format is just like this  {from..to..step}
# so for with 5 distance count to 100  we can have this (0..100..5)
#




fruits=("apple" "banana" "orange" "grape")  

for fruit in "${fruits[@]}"
do
    echo "I like $fruit"
done


# ${fruits[@]} in Bash represents the entire array fruits
# notation [@] allows you to access all elements within the array


# In Bash, ${fruits[@]} and ${fruits[*]} are used to access all elements within an array. However, there is a key difference between the two.


# Using ${fruits[@]}:
# apple
# banana
# split
# cherry
__________________________________________________________________

# Using ${fruits[*]}:
# apple banana split cherry


