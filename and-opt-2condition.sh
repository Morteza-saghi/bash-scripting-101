
#!/bin/bash
read -p "plz enter a number: " num1
if [ $num1 -gt 10 ] && [ $num1  -lt 25  ]
then echo "its okay"
else echo "nope try again"
fi
