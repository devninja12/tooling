BUCKET=adetesu40-terraform-backend

# Delete all object versions
aws s3api list-object-versions --bucket "$BUCKET" \
  --query 'Versions[].{Key:Key,VersionId:VersionId}' --output json \
| jq -c '.[]' \
| while read -r item; do
    aws s3api delete-object --bucket "$BUCKET" \
      --key "$(echo "$item" | jq -r .Key)" \
      --version-id "$(echo "$item" | jq -r .VersionId)"
  done

# Delete all delete markers
aws s3api list-object-versions --bucket "$BUCKET" \
  --query 'DeleteMarkers[].{Key:Key,VersionId:VersionId}' --output json \
| jq -c '.[]' \
| while read -r item; do
    aws s3api delete-object --bucket "$BUCKET" \
      --key "$(echo "$item" | jq -r .Key)" \
      --version-id "$(echo "$item" | jq -r .VersionId)"
  done

