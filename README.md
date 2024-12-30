# terraform-labs
Terraform Example with AWS

# Usage

Please you will need the following extra vars in order to test this out

```
#for configure the budget
export TF_VAR_budget_email="your@email_here.com"
```

also you can include this in a script and loaded in your env something like below

```
source .secrets
```

# Statefile is created in S3

```
aws s3api create-bucket --bucket terraform-state-vidbaz --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2
```
