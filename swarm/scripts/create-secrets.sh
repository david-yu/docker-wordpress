echo "mysql-root-password-secret" | docker secret create MYSQL_ROOT_PASSWORD -
echo "mysql-password-secret" | docker secret create MYSQL_PASSWORD -
echo "wordpress" | docker secret create MYSQL_USER -
echo "wordpress" | docker secret create MYSQL_DATABASE -
docker secret ls
