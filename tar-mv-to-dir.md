### PT1 





```
#!/bin/bash

# Get a list of all files and directories in the current directory and store them in the 'arr' array
arr=(`ls ./`)

# Generate a timestamp variable
dateis=$(date +"%y-%m-%d-AT%H")

mkdir -p ./$dateis

# Iterate over 'arr' array
for f in "${arr[@]}"
do
   # compress and archive each dir and store it in the timestamped directory
   tar czvf ./$dateis/$f.tar.gz ./$f
done

```
