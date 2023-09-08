cont_names=$(docker container ls -q)

#echo $cont_names

for i in $cont_names

do docker inspect -f '{{.NetworkSettings.Networks.bridge.IPAddress }}' $i

done

  

# easy bash code to see ip add of running containers 
