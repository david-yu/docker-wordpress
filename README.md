Docker Wordpress Example
=====================

A Wordpress example that can deploy on Docker Datacenter through the UI or CLI

DDC and Docker 1.13
-------------------

### Deploy using Docker Compose File
```
# Source client bundle
cd ucp-bundle-admin
source env.sh

# Deploy using Compose File
docker stack deploy -c docker-compose.yml wordpress
```

### Deploy using `docker service` commands
```
# Source client bundle
cd ucp-bundle-admin
source env.sh

docker network create --driver overlay wordpress-network
docker service create --replicas 1 --network wordpress-network \
--mount type=volume,destination=/data/db -e MYSQL_ROOT_PASSWORD=wordpress \
-e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress -e MYSQL_PASSWORD=wordpress \
--name mariadb mariadb
docker service create --replicas 3 -p 80 --network ucp-hrm --network wordpress-network \
-e WORDPRESS_DB_HOST=mariadb:3306 -e WORDPRESS_DB_PASSWORD=wordpress \
--label com.docker.ucp.mesh.http=80=http://wordpress.david.dtcntr.net \
--name wordpress wordpress
```
