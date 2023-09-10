

docker build -t giprocida/axual-debug:1.0 .

wait

kubectl create role pod-listing-role \
  --verb=get,list \
  --resource=pods,secrets \
  --namespace=kafka \
  --dry-run=client -o yaml > my-role.yaml

wait

kubectl create rolebinding pod-listing-binding \
  --role=pod-listing-role \
  --serviceaccount=kafka:default \
  --dry-run=client \
  --namespace=kafka \
  -o yaml > my-role-binding.yaml

wait


kubectl run debug-pod --image=giprocida/axual-debug:1.0 \
  --namespace=kafka \
  --dry-run=client \
  -o yaml > debug-pod.yaml


echo " "
echo "Now modify the pod configuration by adding imagePullPolicy: Never 
beneath the 'image' field."
