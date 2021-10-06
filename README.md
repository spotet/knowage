# knowage

* Création du build config permettant de construire l'image à partir du Dockerfile présent dans le dépôt ci-présent
```bash
     oc new-build https://gitn.svc.sigma.host/sigma/paas/openshift/catalogue-templates.git\#develop \
     -n sigma-infra-buildimages \
     --strategy=docker \
     --context-dir=/knowage \
     --name=knowage-sigma \
     --build-env=GIT_SSL_NO_VERIFY=true \
     --source-secret=gitn-catalogue-token
```

* Publication de l'image dans le projet openshift
```
#> oc tag knowage sigma-infra-buildimages/knowage-sigma:latest -n sigma-infra-buildimages
#> oc tag knowage-sigma openshift/knowage-sigma:latest -n sigma-infra-buildimages
```
* Template

     ONGOING

* Test on project
```bash
oc new-app --image-stream=sigma-infra-buildimages/knowage-sigma --name knowage
```