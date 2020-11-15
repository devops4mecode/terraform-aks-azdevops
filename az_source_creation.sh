#!/usr/bin/env bash

#Azure Credentials & Subs Details
azUsername="najibradzuan@devops4me.com"
azPassword="N@jib1607"
azSubsID="c78ae655-e599-44ee-b71d-c384b359eb81"
azTenantID="18c0d54f-628e-4386-97f0-c96cb64d5be8"

#Set all variables;
azResourceGroup="do4m_aks_demo_rsg"
azLocation="southeastasia"
azStorageAccount="do4mterraformstate"
azStorageContainer="tfstate"
azStorageKey="i5gJDWFeuKpifJe789IdmRsjm943KmbbFtAeJoMIlOyz23L7DiAKcTIBwk847w9W+WVzCmxeyqGJQGPz74jmog=="
azKeyVault="do4mkeyvault"
azSASToken="do4mSASToken"
azSASTokenValue=""
azServicePrinciple="do4mAksTerraformSPN"
azServicePrincipleID="spn-id"
azServicePrincipleSecret="spn-secret"


#Execute Azure CLI for the following resources:
#Prerequisite;

#Login
az login -u $azUsername -p $azPassword

#1: creating the resource Group
az group create -n $azResourceGroup -l $azLocation

#2: creating the storage account
az storage account create -n $azStorageAccount -g $azResourceGroup -l $azLocation

#3: creating a tfstate container
az storage container create -n $azStorageContainer --account-name $azStorageAccount

#4: creating the KeyVault
az keyvault create -n $azKeyVault -g $azResourceGroup -l $azLocation

#5: Creating a SAS Token for the storage account, storing in KeyVault
az storage container generate-sas --name $azStorageContainer --expiry 2022-01-01  \
--permissions dlrw --account-name $azStorageAccount --account-key $azStorageKey -o json | xargs \
az keyvault secret set --vault-name $azKeyVault --name $azSASToken --value

#6: creating a Service Principal for AKS and Azure DevOps
az ad sp create-for-rbac -n $azServicePrinciple

#7: creating an ssh key if you don't already have one
ssh-keygen  -f ~/.ssh/id_rsa_terraform

#8: store the public key in Azure KeyVault
az keyvault secret set --vault-name $azKeyVault --name LinuxSSHPubKey -f ~/.ssh/id_rsa_terraform.pub > /dev/null

#store the service principal id in Azure KeyVault
az keyvault secret set --name $azServicePrincipleID --value "b03f8d7d-8b74-4f69-a17c-ddc5bf8fc019" --vault-name $azKeyVault 

#store the service principal secret in Azure KeyVault
az keyvault secret set --name $azServicePrincipleSecret --value "Ho-iv-3WOTCiNvP5Ct-.e9nfuAX8Mkrny~" --vault-name $azKeyVault