#!/bin/bash

current_dir=$(cd "$(dirname "$0")" && pwd)
src_file=source_file.txt
dir_name=terraform-aws

file_name=$(basename "$src_file")
main_file=$file_name
sub_file=source.txt

first_line=$(head -n 1 "$current_dir/$src_file") # テキストファイルの1行目を読み込む

function create_source_file () {
  cat << EOF > "$current_dir"/$sub_file
# variable

ACCESS_KEY=

SECRET_KEY=

AWS_REGION=

PROFILE=

ANOTHER_USER=

ANOTHER_USER_GROUP=

MAIL_ADDRESS=
EOF
}

if [ ! -e $src_file ] || [ ! -f $src_file ]; then
  echo -e "\033[1;31mERROR: ソースファイルが存在しない、またはパスの指定に誤りがあります。対象のファイルを $current_dir に生成します。\033[0m"
  create_source_file
  exit 1
elif [[ ! $first_line =~ "# variable" ]]; then
  echo -e "\033[1;31mERROR: ソースファイル $main_file は無効です。\033[0m"
  echo -e "\033[1;31mERROR: ソースファイル $main_file の一行目に適切な修正を行って再度実行してください。\033[0m"
  exit 1
else
  echo -e "\033[1;32mSUCCESS: ソースファイル $src_file は有効です。\033[0m"
fi

function terraform_code-basic () {

  mkdir "$current_dir"/"$dir_name"
  cd "$current_dir"/"$dir_name" || exit

  cat << EOF >> iam.tf
# IAM ユーザーを作成する(事前にコンソール上で「AdministratorAccess」という許可ポリシーを付与したユーザーを作成しておくこと)
# ユースケースで「コマンドラインインターフェイス (CLI)」を選択してアクセスキーとシークレットアクセスキーを設定する

resource "aws_iam_user" "$ANOTHER_USER" {
  name = "$ANOTHER_USER"
  path = "/"
}

resource "aws_iam_role" "admin" {
  name = "admin-policy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action : [
          "sts:AssumeRole"
          # "sso:ListInstances",
          # "iam:GetGroup",
          # "identitystore:GetUserId",
          # "identitystore:Describe*"
        ],
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role" "$ANOTHER_USER" {
  name = "$ANOTHER_USER"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_access_key" "$ANOTHER_USER" {
  user = aws_iam_user.$ANOTHER_USER.name
}

# IAM グループを作成する

resource "aws_iam_group" "$ANOTHER_USER_GROUP" {
  name = "$ANOTHER_USER_GROUP" # IAM グループ名を指定
  path = "/"
}

resource "aws_iam_policy_attachment" "$ANOTHER_USER" {
  name       = "$ANOTHER_USER"
  users      = [aws_iam_user.$ANOTHER_USER.name]
  roles      = [aws_iam_role.$ANOTHER_USER.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # ポリシーARNを適切な値に変更してください
}

resource "aws_iam_user_login_profile" "$ANOTHER_USER" {
  user                    = aws_iam_user.$ANOTHER_USER.name
  password_length         = "10"
  password_reset_required = true # パスワードの変更を要求する場合は true に設定
}

# IAM ポリシードキュメントを設定する

data "aws_iam_policy_document" "$ANOTHER_USER" {
  statement {
    effect    = "Allow"
    actions   = ["iam:ReadOnlyAccess"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "$ANOTHER_USER" {
  name   = "${ANOTHER_USER}_ReadOnlyAccess" // 許可ポリシーの名前を設定
  user   = aws_iam_user.$ANOTHER_USER.name
  policy = data.aws_iam_policy_document.$ANOTHER_USER.json
}
EOF

  cat << EOF >> main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
  profile    = var.profile
}
EOF

  cat << EOF >> terraform.tfvars
aws_access_key = "$ACCESS_KEY"
aws_secret_key = "$SECRET_KEY"
EOF

  cat << EOF >> variables.tf
variable "aws_access_key" {
  description    = "AWS_ACCESS_KEY_ID"
  type           = string
  sensitive      = true
}

variable "aws_secret_key" {
  description    = "AWS_SECRET_ACCESS_KEY"
  type           = string
  sensitive      = true
}

variable "region" {
  description = "AWS_REGION"
  default     = "$AWS_REGION"
}

variable "profile" {
  default = "$PROFILE"
}
EOF

  cat << EOF >> aws-sso.tf
# IAM Identity Center の詳細画面にある情報を取得する

data "aws_ssoadmin_instances" "this" {}

output "arn" {
  value = tolist(data.aws_ssoadmin_instances.this.arns)[0]
}

output "identity_store_id" {
  value = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

# IAM Identity Center のユーザーを作成する

resource "aws_identitystore_user" "$ANOTHER_USER" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.$ANOTHER_USER.identity_store_ids)[0]

  display_name = "$ANOTHER_USER"
  user_name    = "$ANOTHER_USER"

  name {
    given_name  = "$ANOTHER_USER"
    family_name = "2" # Error: expected length of family_name to be in the range (1 - 1024), got 回避のため適当な文字列を入れる
  }

  emails {
    primary = true
    type    = "work"
    value   = "$MAIL_ADDRESS"
  }
}

# IAM Identity Center のユーザーを取得する

data "aws_ssoadmin_instances" "$ANOTHER_USER" {}

# data "aws_identitystore_user" "$ANOTHER_USER" {
#   identity_store_id = tolist(data.aws_ssoadmin_instances.$ANOTHER_USER.identity_store_ids)[0]

#   alternate_identifier {
#     unique_attribute {
#       attribute_path  = "UserName" # UserName とすることでユーザーを正しく特定できる
#       attribute_value = "$ANOTHER_USER" # IAM Identity Center に追加したユーザー名を入力
#     }
#   }
# }

# output "user_id" {
#   value = data.aws_identitystore_user.$ANOTHER_USER.user_id
# }
EOF

  echo -e "\033[1;32mALL SUCCESSFUL: ファイルの出力処理が正常に終了しました。\033[0m"
  echo -e "\033[1;32m$dir_name は $current_dir/$dir_name に格納されています。\033[0m"
  echo
}

source $(dirname "${BASH_SOURCE[0]}")/$src_file

# if [ "$environment1" = "true" ]; then
#   base_terraform
# elif [ "$environment1" = "true" ]; then
#   echo -e "\033[1;35mINFO: environment1 関数は無効になります。\033[0m"
# else
#   echo
# fi

if [[ $first_line =~ "# variable" ]]; then
  terraform_code-basic
fi
