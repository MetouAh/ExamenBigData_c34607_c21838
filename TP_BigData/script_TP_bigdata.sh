
echo " Démarrage du cluster Hadoop..."

cd hadoop-docker || exit

docker-compose up -d

docker ps

echo " Cluster démarré"




echo " Vérification cluster..."

docker ps

echo " Ouvrir : http://localhost:9870"


#upload le dataset et le copier sur hdfs

FILE="C:\\Users\\Hp EliteBook x360\\Documents\\FST\\S2_M1\\big data\\yellow_tripdata_2023-01.csv"

echo " Copie vers Docker..."

docker cp "$FILE" namenode:/tmp/

echo " Création dossier HDFS..."

docker exec namenode bash -c "hdfs dfs -mkdir -p /tphdfs/data"

echo " Upload vers HDFS..."

docker exec namenode bash -c "hdfs dfs -put /tmp/yellow_tripdata_2023-01.csv /tphdfs/data/"

echo " Upload terminé"



echo " Liste fichiers HDFS"

docker exec namenode bash -c "hdfs dfs -ls /tphdfs/data/"

echo " Réplication"

docker exec namenode bash -c "hdfs dfs -stat '%r' /tphdfs/data/yellow_tripdata_2023-01.csv"

echo " Blocs HDFS"

docker exec namenode bash -c "hdfs fsck /tphdfs/data/yellow_tripdata_2023-01.csv -files -blocks -locations"



#modification des prioritaire + merge de fichiers

echo " chmod 600"

docker exec namenode bash -c "hdfs dfs -chmod 600 /tphdfs/data/personnes.txt"

echo " chown"

docker exec namenode bash -c "hdfs dfs -chown root:supergroup /tphdfs/data/personnes.txt"

echo " create local file"

docker exec namenode bash -c "echo 'nouvelle ligne' > /tmp/local.txt"

echo " appendToFile"

docker exec namenode bash -c "hdfs dfs -appendToFile /tmp/local.txt /tphdfs/data/personnes.txt"

echo " merge files"

docker exec namenode bash -c "hdfs dfs -getmerge /exercices/rapports/ /tmp/fusion.txt"

echo " terminé"


#activation et desactivation de datanodes 

echo " Stop datanode1"

docker stop datanode1

sleep 5

echo " Start datanode1"

docker start datanode1

docker ps


echo " Arrêt cluster Hadoop..."

docker-compose down


echo " terminé"
