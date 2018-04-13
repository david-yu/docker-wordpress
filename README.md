Docker Wordpress Example
=====================

A Wordpress example that can deploy on Docker Datacenter through the UI or CLI

## Kubernetes - Docker EE 2.0 Standard or Advanced

```
# Source client bundle
cd ucp-bundle-admin
source env.sh

# CD to folder with k8s yaml files
kubectl apply -f mysql-demo.yaml
kubectl apply -f wordpress-demo.yaml
```

## Swarm - Docker EE 2.0 Standard or Advanced

### Deploy using Docker Compose File without Secrets
```
# Source client bundle
cd ucp-bundle-admin
source env.sh

# Deploy using Compose File
export WORDPRESS_DOMAIN=wordpress.local
docker stack deploy -c docker-compose-no-secrets.yml wordpress
```

### Deploy using Docker Compose File using Secrets and Configurable Domain (Recommended)

#### Source client bundle

```
# Source client bundle
cd ucp-bundle-admin
source env.sh
```

#### Create Secrets via Script

```
./scripts/create-secrets.sh
```

#### Create Secrets Manually

```
echo "mysql-root-password-secret" | docker secret create MYSQL_ROOT_PASSWORD -
shx8bnn6qkoqkqqans4pu1e8w

echo "mysql-password-secret" | docker secret create MYSQL_PASSWORD -
isn62qaix8fxnq9dojqtf466s

echo "wordpress" | docker secret create MYSQL_USER -
v2mz2i9ei5g9i3zv7cpy1o9am

echo "wordpress" | docker secret create MYSQL_DATABASE -
khoy0gkn334m4hapbmef12svj

docker secret ls
ID                          NAME                  CREATED              UPDATED
isn62qaix8fxnq9dojqtf466s   MYSQL_PASSWORD        About a minute ago   About a minute ago
khoy0gkn334m4hapbmef12svj   MYSQL_DATABASE        50 seconds ago       50 seconds ago
shx8bnn6qkoqkqqans4pu1e8w   MYSQL_ROOT_PASSWORD   About a minute ago   About a minute ago
v2mz2i9ei5g9i3zv7cpy1o9am   MYSQL_USER            About a minute ago   About a minute ago
```
#### Deploy to Swarm using Compose File

```
export WORDPRESS_DOMAIN=wordpress.david.dtcntr.net
docker stack deploy -c docker-compose-secrets-domain.yml wordpress
```

### Deploy using Docker Compose File using Secrets
```
# Source client bundle
cd ucp-bundle-admin
source env.sh

# Create Secrets

echo "mysql-root-password-secret" | docker secret create MYSQL_ROOT_PASSWORD -
shx8bnn6qkoqkqqans4pu1e8w

echo "mysql-password-secret" | docker secret create MYSQL_PASSWORD -
isn62qaix8fxnq9dojqtf466s

echo "wordpress" | docker secret create MYSQL_USER -
v2mz2i9ei5g9i3zv7cpy1o9am

echo "wordpress" | docker secret create MYSQL_DATABASE -
khoy0gkn334m4hapbmef12svj

docker secret ls
ID                          NAME                  CREATED              UPDATED
isn62qaix8fxnq9dojqtf466s   MYSQL_PASSWORD        About a minute ago   About a minute ago
khoy0gkn334m4hapbmef12svj   MYSQL_DATABASE        50 seconds ago       50 seconds ago
shx8bnn6qkoqkqqans4pu1e8w   MYSQL_ROOT_PASSWORD   About a minute ago   About a minute ago
v2mz2i9ei5g9i3zv7cpy1o9am   MYSQL_USER            About a minute ago   About a minute ago

# Deploy using Compose File
# NOTE: modify com.docker.ucp.mesh.http label prior to deploying with correct domain name
docker stack deploy -c docker-compose-secrets.yml wordpress
```

## Swarm - Docker CE

Run Wordpress on your local engine before deploying on production (Docker EE)

```
# Deploy using Compose File
docker stack deploy -c docker-compose-ce.yml wordpress
```

### Deploy Wordpress using `docker service` commands

#### Deploy Services via Script
```
./scripts/run-wordpress-service.sh
```


#### Deploy Services manually
```
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
