kubectl port-forward deploy/cimple-front-deployment 8080:80 &
kubectl port-forward pod/cimple-back 8081:8000 &
kubectl port-forward pod/cimple-eviewer 8082:5000

