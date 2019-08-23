# Put this script in Jenkins "Execute Shell"
set +x

role_arn="arn:aws:iam::055017164448:role/Jenkins_Role"

aws_credentials_json=$(aws sts assume-role --role-arn $role_arn --role-session-name ${Account} --region ap-south-1)
export AWS_ACCESS_KEY_ID=$(echo $aws_credentials_json | jq --exit-status --raw-output .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $aws_credentials_json | jq --exit-status --raw-output .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $aws_credentials_json | jq --exit-status --raw-output .Credentials.SessionToken)
set -x

ls -lart
cp -r ./cloud_infra/templates/vpc/*.tf ./cloud_infra/tfvars/vpc_01
cd ./cloud_infra/tfvars/vpc_01

auto_approve=""
if [ ${terraform_action} != "plan"]
then
auto_approve="-auto-approve"
fi

TF_LOG=error /usr/local/bin/terraform init -upgrade \
    -backend-config="bucket=${STATE_BUCKET}" \
    -backend-config="key=accounts/${S3_Path}/${Module}/terraform.tfstate" \
    -backend-config="region=${AWS_REGION}"
    

TF_LOG=error /usr/local/bin/terraform ${Terraform_Action} $auto_approve \
      -var "state_bucket=${STATE_BUCKET}" \
      -var "state_region=${AWS_REGION}"
