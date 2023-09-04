
### How to run it?###

# Build the image on the current working directory

docker build -t giprocida/axual-debug:1.0

# Create a role resource

kubectl create role pod-listing-role --verb=get,list --resource=pods,secrets --namespace=kafka 
--dry-run=client -o yaml > my-role.yaml



# Create a rolebinding resource that binds the pod-listing-role to the default ServiceAccount
kubectl create rolebinding pod-listing-binding \
  --role=pod-listing-role \
  --serviceaccount=kafka:default \
  --dry-run=client \
  --namespace=kafka \
  -o yaml > my-role-binding.yaml


# Create a pod using the image giprocida/axual-debug:1.0 

kubectl run my-pod --image=giprocida/axual-debug:1.0 --namespace=kafka --dry-run=client -o yaml > 
my-pod.yaml

# Add imagePullPolicy: Never in the my-pod.yaml file

# Run the script:bash run-debug.sh
