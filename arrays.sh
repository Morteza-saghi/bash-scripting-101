arrays 


# to define an array we do like this 

thisarr=(1) # an array with one value 

thisarr=(1 2 3 4) # an array with 4 values


# how to add a value to the array
thisarr+=(newchar)
#outpot ==== > thisarr=(1 hello)

#Remove elements

thisarr=(1 hello 2 3 4 5)
unset thisarr[1] # Remove element at index 1 (which is "hello")
