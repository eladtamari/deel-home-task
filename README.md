
#  1. gcloud use sa for authentication

#  2. port-forward 
  kubectl port-forward --namespace default svc/my-mongodb-1 27017:27017 &
  mongosh --host 127.0.0.1 --authenticationDatabase user -p pass &


  helm upgrade --install deel-croc-1 ./new-deploy --namespace default  --set db_user="user" --set db_pass="pass"

# CLI: gcloud permmisions

gcloud iam service-accounts add-iam-policy-binding "github-actions@deel-home-task-1.iam.gserviceaccount.com" \
--project="deel-home-task-1" \
--role="roles/iam.workloadIdentityUser" \
--member="principalSet://iam.googleapis.com/projects/499613830332/locations/global/workloadIdentityPools/deel/attribute.repository/eladtamari/deel-home-work"

gcloud iam service-accounts add-iam-policy-binding "github-actions-sa@deel-home-task-1.iam.gserviceaccount.com" \
--project="deel-home-task-1" \
--role="roles/iam.serviceAccountTokenCreator" \
--member="principalSet://iam.googleapis.com/projects/499613830332/locations/global/workloadIdentityPools/deel/attribute.repository/eladtamari/deel-home-work"

gcloud iam service-accounts add-iam-policy-binding "github-actions-sa@<YOUR_PROJECT_ID>.iam.gserviceaccount.com" \
--role="roles/iam.serviceAccountTokenCreator" \
--member="principalSet://iam.googleapis.com/projects/<YOUR_PROJECT_NUMBER>/locations/global/workloadIdentityPools/github-actions-pool/attribute.repository/<YOUR_GITHUB_USERNAME>/<YOUR_REPO_NAME>"

gcloud projects add-iam-policy-binding deel-home-task-1 \
--member="serviceAccount:"github-actions-sa@deel-home-task-1.iam.gserviceaccount.com"" \
--role="roles/container.clusterAdmin"
