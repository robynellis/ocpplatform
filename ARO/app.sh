oc new-app bitnami/mongodb \
-e MONGODB_USERNAME=ratingsuser \
-e MONGODB_PASSWORD=ratingspassword \
-e MONGODB_DATABASE=ratingsdb \
-e MONGODB_ROOT_USER=root \
-e MONGODB_ROOT_PASSWORD=ratingspassword

oc new-app https://github.com/thotheod/mslearn-aks-workshop-ratings-api --strategy=source --name=rating-api

oc set env deploy/rating-api MONGODB_URI=mongodb://ratingsuser:ratingspassword@mongodb.workshop.svc.cluster.local:27017/ratingsdb

oc new-app https://github.com/rellismicrosoft/mslearn-aks-workshop-ratings-web.git --strategy=docker --name=rating-web