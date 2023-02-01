#ENV VARS
export RESOURCEGROUP=arotest
export CLUSTER=arotest
export AROVNET=arovnet
export LOCATION=eastus
export AROVNET_PREFIX="10.0.0.0/16"
export MASTERAROSUBNET_NAME="aromaster_subnet"
export MASTERAROSUBNET_PREFIX="10.0.1.0/24"
export WORKERAROSUBNET_NAME="aroworker_subnet"
export WORKERAROSUBNET_PREFIX="10.0.2.0/24"
export apiServer=$(az aro show -g $RESOURCEGROUP -n $CLUSTER --query apiserverProfile.url -o tsv)
export RH_PULLSECRET=

#Create RG
az group create --location $LOCATION --resource-group $RESOURCEGROUP

#Networking

az network vnet create \
--resource-group $RESOURCEGROUP \
--name $AROVNET \
--address-prefixes $AROVNET_PREFIX

az network vnet subnet create \
--resource-group $RESOURCEGROUP \
--vnet-name $AROVNET \
--name $MASTERAROSUBNET_NAME \
--address-prefixes $MASTERAROSUBNET_PREFIX

az network vnet subnet create \
--resource-group $RESOURCEGROUP \
--vnet-name $AROVNET \
--name $WORKERAROSUBNET_NAME \
--address-prefixes $WORKERAROSUBNET_PREFIX

#CREATE CLUSTER
az aro create --resource-group $RESOURCEGROUP \
--name $CLUSTER \
--vnet $AROVNET \
--master-subnet $MASTERAROSUBNET_NAME \
--worker-subnet $WORKERAROSUBNET_NAME \
--pull-secret $RH_PULLSECRET

#WAIT FOR COMPLETION

#GET KUBEADMIN CREDS
az aro list-credentials \
--name $CLUSTER \
--resource-group $RESOURCEGROUP

#DOWLOAD/INSTALL OC CLIENT
cd ~
wget https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
mkdir openshift
tar -zxvf openshift-client-linux.tar.gz -C openshift
echo 'export PATH=$PATH:~/openshift' >> ~/.bashrc && source ~/.bashrc

apiServer=$(az aro show -g $RESOURCEGROUP -n $CLUSTER --query apiserverProfile.url -o tsv)

