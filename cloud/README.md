========== Install plugin workaround on jump server ================
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt update
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin kubectl
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

#get cluster credentials
gcloud container clusters get-credentials saips-gke  --zone us-east5-a