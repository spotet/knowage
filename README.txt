https://github.com/spotet/knowage/blob/master/Dockerfile
https://release.ow2.org/knowage/8.0.0/Applications/
https://github.com/KnowageLabs/Knowage-Server-Docker/blob/master/Knowage-Server-Docker/Dockerfile
https://github.com/KnowageLabs/Knowage-Server-Docker/tree/master/Knowage-Server-Docker
https://github.com/KnowageLabs/Knowage-Server-Docker/tree/knowage-server-8.0/Knowage-Server-Docker
https://github.com/KnowageLabs/Knowage-Server-Docker/blob/knowage-server-8.0/Knowage-Server-Docker/Dockerfile

https://github.com/flopezag/openshift-knowage
http://download.forge.ow2.org/knowage/

sh-4.2$ cat ./webapps/knowage/themes/sbi_default/jsp/login.jsp
The userid/password is biadmin/biadmin

oc new-app --template=openshift/mariadb-ephemeral --name mariadb2 -p APPLICATION=mariadb2 -p MYSQL_DATABASE=knowage
oc new-app --template=spo-dev/knowage-claims --name knowage -p APPLICATION=knowage-spo2 -p MARIADB_SERVICE=mariadb2

oc delete all,cm,secret -l app=knowage-spo -n spo-dev
oc delete cm wait-for-it -n spo-dev
oc delete all,cm,secret -l app=mariadb -n spo-dev