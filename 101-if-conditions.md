## Bash If Conditions Tutorial
This repository provides a tutorial on how to use if conditions in Bash scripting. Conditional statements are fundamental in scripting and programming, allowing you to execute code based on specific conditions.

### Introduction
In Bash, if conditions allow you to perform different actions based on the outcome of a test or comparison. This tutorial will guide you through the basics of using if conditions in Bash.
Basic Syntax

The basic syntax of an if condition in Bash is as follows:

```
if [ condition ]
then
#Block of Code
fi
```

Like :

```
if [ 1==1 ]
then
echo hello
fi
```


---

- in String comparison "" would mean as null or nothing

```

A=$1

if [ "$A" == "" ]
then 
echo this is null 
else 
echo hey u have entered some shit
fi
``` 

---


### conditions with an else part:

```
if [ condition ]
then
# Block of code to execute if condition is true
else
# Block of code to execute if condition is false
fi
```


Like:

```
num1=$1
num2=$2

if [ $num1 == $num2  ]
then
    echo " equal " 
else
    echo not equal
fi
```

Or:

```
name=$1

if [ "$name" = "A" ]; then
echo "This is if $name"
else
echo "The rest will see this"
fi
```

notice the diffrence between how we would compare strings and nums  

---

#### In Bash, the correct operator for string comparison is =, not ==

---

#### For multiple conditions:

```
if [ condition1 ]
then
# code to execute if condition1 is true
elif [ condition2 ]
then
# code to execute if condition2 is true
else
# code to execute if none of the conditions are true
fi
```


Like:

```
name=$1

if [ $name = A  ]
then
echo A
# code to execute if condition1 is true
elif [  $name = B  ]
then
echo B
# code to execute if condition2 is true
else
echo some other shit
# code to execute if none of the conditions are true
fi
```
---

### Comparison Operators

Here are some commonly used comparison operators in Bash:

    -gt: greater than
    -ge: greater than or equal to
    -lt: less than
    -le: less than or equal to
    -eq: equal to
    -ne: not equal to

These operators are used to compare numeric values. For string comparisons, you can use:

    =: equal to
    !=: not equal to
    <: lexicographically less than
    >: lexicographically greater than

Examples:

```
read -p "Enter a number: " number
if [ "$number" -gt 10 ]
then
echo "The number is greater than 10."
fi
```


Or

```
num=$1

if [ $num -gt 10  ]
then 
echo its bigger than 10 fuck
else
echo its realy small
fi
```
---

### to A++ a var 


```
A=5
((A++))
echo $A  # Output will be 6
```

Using let:

```
A=5
let A++
echo $A  # Output will be 6
```

Explanation:

- ((A++)) and let A++ both increment the value of A by 1. 





---

#### If-Else Statement

```
#!/bin/bash

read -p "Enter a number: " number
if [ "$number" -gt 10 ]; then
    echo "The number is greater than 10."
else
    echo "The number is 10 or less."
fi
```

---

#### If-Elif-Else Statement

```

#!/bin/bash

read -p "Enter a number: " number
if [ "$number" -gt 10 ]; then
    echo "The number is greater than 10."
elif [ "$number" -eq 10 ]; then
    echo "The number is exactly 10."
else
    echo "The number is less than 10."
fi
```
