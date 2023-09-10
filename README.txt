
### How to Run ###

Follow these steps to build a Docker image, create Kubernetes resources, and run a pod.


# Build the docker image

docker build -t giprocida/axual-debug:1.0 .

# Create a role resource named 'pod-listing-role' with specific permission

kubectl create role pod-listing-role \
  --verb=get,list \
  --resource=pods,secrets \
  --namespace=kafka \
  --dry-run=client -o yaml > my-role.yaml


# Create a rolebinding resource that binds the pod-listing-role to the default ServiceAccount

kubectl create rolebinding pod-listing-binding \
  --role=pod-listing-role \
  --serviceaccount=kafka:default \
  --dry-run=client \
  --namespace=kafka \
  -o yaml > my-role-binding.yaml


# Create a pod using the image giprocida/axual-debug:1.0 

kubectl run debug-pod \
  --image=giprocida/axual-debug:1.0 \
  --namespace=kafka \
  --dry-run=client -o yaml > debug-pod.yaml

# Modify the pod configuration by adding

imagePullPolicy: Never 

within the 'containers' field

# Apply all the newly created resources.


# The previously described procedure is automated through the use of the scripts: create-resources.sh and run-debug.sh.

# Run the script create-resource.sh to create all the necessary resources
# Run the script run-debug.sh to apply all the newly created resources:

