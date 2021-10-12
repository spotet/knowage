# Knowage Claims SPaaS

Ce fichier regroupe toutes les informations nécessaires au déploiement de Knowage Claims vers la plateforme SPaaS.

L'architecture de cette application sur SPaaS comprend divers composants supplémentaires en plus de l'application :
- Une base de données [MariaDB] pour persister les données des applications

## Création

Cette section récapitule les différentes étapes pour instancier l'entièreté de l'achitecture sur SPaaS.

**/!\ Veuillez respecter l'ordre du document pour éviter tout problème /!\\**

### MariaDB

Pour déployer le MariaDB, déployer le Template Openshift MariaDB depuis le catalogue (Attention ne pas utiliser la version Ephemeral !), nommer la database :
``` bash
 mariadb-<client>
```

Un sercret mariadb-"client" est généré contenant les identifiants et la nom de la base données.

### Imagestream Knowage

L'accès GitHub depuis Openshift nécessite un username/password qui se trouve dans le projet agvs-ageval-dev sous le nom "gitlab-keycloak". Ce pré-requis est obligatoire pour le bon fonctionnement du build.

Pour créer l'imagestream Knowage Claims customisée, il est d'abord nécessaire de créer le buildconfig. Pour cela, exécuter la commande suivante :
``` bash
oc create -f bc-knowage.yaml
```

Le build se lancera alors automatiquement.

Si vous voulez relancer le build :
``` bash
oc start-build claims-knowage
```

### Template

Pour instancier le template de l'application , il faut préciser différentes informations :
- Le nom de l'application (nom de l'application) APPLICATION
- Le FQDN de la route publique APPLICATION_PUBLIC_DOMAIN
- L'adresse d'accès à la BDD (Nom du service openshift MariaDB) MARIADB_SERVICE
- L'imagestream Knowage (Nom de l'imagestream openshift) KNOWAGE_IS (Default knowage)
- Version du tag de l'imagestream knowage (Nom du tag de l'imagestream openshift) KNOWAGE_VERSION (Default 8.0.0)
- Request et Limit de l'application knowage (Request at Limit) MEMORY_LIMIT / CPU_LIMIT / MEMORY_REQUEST / CPU_REQUEST

Pour créer le template, exécuter la commande suivante :
``` bash
oc create -f template-claims-knowage.yaml
```

Instancier ensuite l'application en utilisant le template depuis le portail Openshift (knowage-claims) ou en ligne de commande :
``` bash
oc new-app --template=<PROJECT NAME>/knowage-claims --name knowage -p APPLICATION=<APPLICATION NAME> -p MARIADB_SERVICE=<MARIADB SERVICE NAME> -p APPLICATION_PUBLIC_DOMAIN=<ROUTE NAME>
```

### Premier déploiement

Le mot de passe du compte "biadmin" de knowage est "biadmin" par défaut.