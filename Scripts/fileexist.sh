
echo "whats the file name " 
read filename
if [ ! -f "$filename" ]
then echo "ok "
else echo "error"
fi



# ! is like logaical not
# what this file does  is that if the file
# is not there it say its okay to make the file 
