# Notes

Day 1

- init project

````
- terraform init
- terraform validate
'''

Day 2: IAM as code

1) Create SA Terraform

PROJECT_ID="atlas-data-platform"
gcloud config set project "$PROJECT_ID"

gcloud iam service-accounts create tf-admin \
 --display-name="Terraform Admin"

2) Give Role to SA

TF_SA="tf-admin@$PROJECT_ID.iam.gserviceaccount.com"

# Rôles projet
for role in \
 roles/resourcemanager.projectIamAdmin \
 roles/iam.serviceAccountAdmin \
 roles/serviceusage.serviceUsageAdmin \
 roles/storage.admin \
 roles/bigquery.admin \
 roles/secretmanager.admin
do
 gcloud projects add-iam-policy-binding "$PROJECT_ID" \
   --member="serviceAccount:$TF_SA" \
   --role="$role"
done

# Autoriser TOI à impersonate tf-admin (pour Terraform local sans clé)
MY_USER="user:erwan.allain@gmail.com"
gcloud iam service-accounts add-iam-policy-binding "$TF_SA" \
 --member="$MY_USER" \
 --role="roles/iam.serviceAccountTokenCreator"



#Check after creation

## 🔎 Post-Apply Verification — Workload Identity Federation

### 1️⃣ Vérifier que le Workload Identity Pool existe
```bash
gcloud iam workload-identity-pools list --location=global --project=atlas-data-platform
````

### 2️⃣ Vérifier que le Provider GitHub existe

```bash
gcloud iam workload-identity-pools providers list --location=global --workload-identity-pool=github --project=atlas-data-platform
```

### 3️⃣ Inspecter le Provider (remplacer PROVIDER_NAME)

```bash
gcloud iam workload-identity-pools providers describe PROVIDER_NAME --location=global --workload-identity-pool=github --project=atlas-data-platform
```

### 4️⃣ Vérifier le binding IAM sur le Service Account (impersonation)

```bash
gcloud iam service-accounts get-iam-policy tf-admin@atlas-data-platform.iam.gserviceaccount.com --project=atlas-data-platform
```

### 5️⃣ Vérifier les rôles projet du Service Account

```bash
gcloud projects get-iam-policy atlas-data-platform --flatten="bindings[].members" --filter="bindings.members:serviceAccount:tf-admin@atlas-data-platform.iam.gserviceaccount.com" --format="table(bindings.role)"
```

### 6️⃣ Vérifier que les APIs IAM sont activées

```bash
gcloud services list --enabled --project=atlas-data-platform | grep iam
```

https://docs.cloud.google.com/iam/docs/workload-identity-federation
https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication

How to launch terraform apply in local
terraform apply -var-file=envs/dev/terraform.tfvars -var="impersonate_sa=tf-admin@atlas-data-platform.iam.gserviceaccount.com"


terraform init -var-file=envs/dev/terraform.tfvars -var="impersonate_sa=tf-admin@atlas-data-platform.iam.gserviceaccount.com"
terraform import -var-file=envs/dev/terraform.tfvars -var="impersonate_sa=tf-admin@atlas-data-platform.iam.gserviceaccount.com" module.bq.google_bigquery_dataset.raw projects/atlas-data-platform/datasets/raw
terraform import -var-file=envs/dev/terraform.tfvars -var="impersonate_sa=tf-admin@atlas-data-platform.iam.gserviceaccount.com" module.bq.google_bigquery_dataset.staging projects/atlas-data-platform/datasets/staging
terraform import -var-file=envs/dev/terraform.tfvars -var="impersonate_sa=tf-admin@atlas-data-platform.iam.gserviceaccount.com" module.bq.google_bigquery_dataset.mart projects/atlas-data-platform/datasets/mart
terraform plan -var-file=envs/dev/terraform.tfvars -var="impersonate_sa=tf-admin@atlas-data-platform.iam.gserviceaccount.com"
terraform apply -var-file=envs/dev/terraform.tfvars -var="impersonate_sa=tf-admin@atlas-data-platform.iam.gserviceaccount.com"
