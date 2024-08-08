# Loops in Bash
Bash provides several types of loops that allow you to execute a set of commands repeatedly. The most common loops in Bash are `for`, `while`, and `until`.

## 1. `for` Loop

The `for` loop iterates over a list of items and executes the commands within the loop for each item.

### Syntax

```
for variable in list
do
commands
done
```

Example: Loop Through a List of Words

```
for word in Hello World Bash Scripting
do
echo $word
done
```

Explanation: This loop iterates over each word in the list (Hello, World, Bash, Scripting) and echoes it.

---

Example: Loop Through a Range of Numbers


```
for i in {1..5}
do
    echo "Number: $i"
done
```

Explanation: This loop prints numbers from 1 to 5.

---

Example: C-style for Loop

```
for ((i=1; i<=5; i++))
do
    echo "Number: $i"
done
```

Explanation: This loop behaves like a C-style loop, iterating from 1 to 5.

---

## `while` Loop
The while loop continues to execute a block of commands as long as the condition is true.

Syntax

```
while [ condition ]
do
commands
done
```

---


Example: Loop Until a Condition is Met

```
counter=1
while [ $counter -le 5 ]
do
    echo "Counter: $counter"
    ((counter++))
done
```

Explanation: This loop runs as long as counter is less than or equal to 5, incrementing counter by 1 each time.

---


## Loop Control: break and continue

### break

Purpose: Exits the loop immediately.
Example:

```
for i in {1..10}
do
if [ $i -eq 5 ]; then
break
fi
echo "Number: $i"
done
```

Explanation: The loop breaks when i equals 5.

---


### continue

Purpose: Skips the rest of the commands in the current iteration and proceeds to the next iteration.
Example:

```
for i in {1..5}
do
if [ $i -eq 3 ]; then
continue
fi
echo "Number: $i"
done
```
Explanation: The loop skips the echo command when i equals 3.
