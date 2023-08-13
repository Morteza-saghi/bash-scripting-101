
#!/bin/bash
echo 'you are here '$PWD''
if [ -d 'newDir' ]
then echo 'you good to go'
else echo 'dont have the needed directory ,wanna me to make it (y,n) ?'
read userC
if [ $userC == 'y' ]
then mkdir newDir
ls
else echo 'bye'
fi
fi




# if with -d option is to check something exists or not

