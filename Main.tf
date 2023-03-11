terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.56.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}


# Create a group called "cloud-engineers"
resource "aws_iam_group" "cloud_engineers" {
  name = "cloud-engineers"
}

# Create IAM users and add to "cloud-engineers" group
variable "user_names" {
  type = list(string)
  default = [
    "oochay@awspartners.com", "sola@awspartners.com",
    "femi@awspartners.com", "ariyo@awspartners.com",
    "emmanuel@awspartners.com", "okezie@awspartners.com",
    "henry@awspartners.com", "nonye@awspartners.com",
  "chere@awspartners.com", "kbhadmus@awspartners.com"]
}

resource "aws_iam_user" "users" {
  for_each = toset(var.user_names)

  name = each.key
}  

# Add users to the group!

resource "aws_iam_group_membership" "membership" {
  
  for_each = aws_iam_user.users

   name = each.value.name
   group = aws_iam_group.cloud_engineers.name
   users = [each.value.name]

}


resource "aws_iam_access_key" "access_keys" {
  for_each = aws_iam_user.users

  user = each.value.name
  
}

output "access_keys" {
  value = {
    for k, access_key in aws_iam_access_key.access_keys:
    k => {
      id     = access_key.id
      secret = access_key.secret
    }
  }
  sensitive = true
}


# new-features addition