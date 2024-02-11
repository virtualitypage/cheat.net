#!/bin/bash

this=$(basename "$0")

function usage () {
  echo "AWS CLI やTerraform の導入・削除を行うスクリプト(MacOS環境用)"
  echo "入力方法: $this [ aws_cli | terraform ] [ --install | --uninstall ]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

# AWS CLI install
function aws_cli_install () {
echo -e "\033[1;32mAWS CLI をインストールしています…\033[0m"
echo "brew install awscli"
brew install awscli
echo
echo -e "\033[1;32m認証情報、リージョン、出力形式を設定します\033[0m"
echo "以下の設定例を基に設定を行って下さい"
message=$(cat << EOF
AWS Access Key ID [None]: ACCESS_KEY_ID
AWS Secret Access Key [None]: SECRET_ACCESS_KEY
Default region name [None]: ap-northeast-1
Default output format [None]: json
EOF
)
echo "$message"
echo
echo "aws configure"
aws configure
echo
echo "aws configure list"
aws configure list
echo

sleep 1

echo
echo -e "\033[1;32m続いて、AWS Single Sign-On (AWS SSO)の設定を行います。\033[0m"
echo
echo -e "\033[1;31mAWS SSO の設定が完了していない場合は、以下の手順に従って設定してください。\033[0m"
procedure=$(cat << EOF
 1. AWS マネジメントコンソールで「IAM Identity Center」を選択
 2. グループを作成 > グループ名を入力して「グループを作成」
 3. ユーザーを追加 > プライマリ情報を設定して「次へ」※ ここで入力するメールアドレスに認証用のメールが送信される。
 4. 2で作成した"グループ名"を選択して「次へ」
 5. "ユーザーの確認と追加"という画面の内容に問題がなければ「ユーザーを追加」
 6. 登録したメールアドレスに「Invitation to join IAM Identity Center」という件名のメールが来たら「Accept invitation」をクリックする。
 7. 作成したユーザーの"新規パスワード"を設定して「新しいパスワードを設定」をクリックする。
 8. 再度サインインするよう求められるので、ユーザー名とパスワードを入力して「サインイン」
 9. 何も設定していない場合は"You do not have any applications."と書かれた画面に遷移する。
10. AWS マネジメントコンソールで「IAM Identity Center」を選択、設定 > アイデンティティソースにある「AWS アクセスポータルの URL」をコピーしておく。
11. "AWS Organizations: AWS アカウント" > 組織構造内のユーザーを選択して「ユーザーまたはグループを割り当て」
12. ユーザー名とグループ名を選択して「次へ」
13. 「許可セットを作成」で"事前定義された許可セットのポリシー"から「AdministratorAccess」を選択して「次へ」
14. "許可セットの詳細を指定"という画面で許可セット名を変更(任意)して「次へ」
15. "許可セットのタイプ"や"許可セットの詳細"に問題がなければ「作成」をクリックする。
16. "AWS Organizations: AWS アカウント" > 組織構造内のユーザーを選択して「ユーザーまたはグループを割り当て」
17. ユーザー名とグループ名を選択して「次へ」
18. 作成した許可セットを選択して「次へ」
19. ユーザー名とグループ名、許可セットに問題がなければ「送信」
20. 指定したアカウントに許可セットが追加されていれば完了(「AWS アクセスポータルの URL」の遷移先に"AWS Account (1)"というものが追加される)
EOF
)
echo "$procedure"

sleep 1

echo
echo -e "\033[1;32mAWS CLI のプロファイル設定を手動で行います。\033[0m"
echo "この設定は、最終的に aws sso login --profile [profile_name] コマンドを使用可能にする為です。"
echo
echo "以下の例を基に設定を行って下さい"
example=$(cat << EOF
[profile [profile_name]]
sso_start_url = https://d-XXXXXXXXXX.awsapps.com/start
sso_region = ap-northeast-1
sso_account_id = 012345678901
sso_role_name = SSOReadOnlyRole
region = ap-northeast-1
output = json
EOF
)
echo "$example"
echo
echo -e "\033[1;32mプロファイル名を入力して下さい [ dev | stg | prd ]\033[0m"
read profile_name

echo -e "\033[1;32mAWS アクセスポータルの URL を入力して下さい(IAM Identity Center のダッシュボードにあります)\033[0m"
read sso_start_url

echo -e "\033[1;32mリージョン名を入力して下さい [ ap-northeast-1 | ap-northeast-2 | ap-northeast-3 ]\033[0m"
read sso_region

echo -e "\033[1;32mアカウント ID を入力して下さい\033[0m"
read sso_account_id

echo -e "\033[1;32mSSO ロール名を入力して下さい [ SSOReadOnlyRole | ... ]\033[0m"
read sso_role_name

echo -e "\033[1;32mリージョン名を入力して下さい [ ap-northeast-1 | ap-northeast-2 | ap-northeast-3 ]\033[0m"
read region

echo -e "\033[1;32moutput ファイルの出力形式を入力して下さい [ json | yaml | text | table ]\033[0m"
read output

echo "" >> ~/.aws/config
echo "[profile $profile_name]" >> ~/.aws/config
echo "sso_start_url = $sso_start_url" >> ~/.aws/config
echo "sso_region = $sso_region" >> ~/.aws/config
echo "sso_account_id = $sso_account_id" >> ~/.aws/config
echo "sso_role_name = $sso_role_name" >> ~/.aws/config
echo "region = $region" >> ~/.aws/config
echo "output = $output" >> ~/.aws/config
echo
echo -e "\033[1;32mAWS CLI のプロファイル設定が完了しました。\033[0m"
echo
echo "which aws"
which aws
echo
echo "aws --version"
aws --version
echo
echo -e "\033[1;32mALL SUCCESEFUL: AWS CLIのインストール・その他初期設定が正常に終了しました。\033[0m"
}

# Terraform install
function terraform_install () {
echo -e "\033[1;32mTerraform をインストールしています…\033[0m"
echo "brew tap hashicorp/tap"
brew tap hashicorp/tap
echo
echo "brew install hashicorp/tap/terraform"
brew install hashicorp/tap/terraform
echo
echo "brew update"
brew update
echo
echo "brew upgrade hashicorp/tap/terraform"
brew upgrade hashicorp/tap/terraform
echo
echo -e "\033[1;32mTerraform の自動補完機能を有効にしています…\033[0m"
echo "terraform -install-autocomplete"
terraform -install-autocomplete
echo -e "\033[1;32mALL SUCCESEFUL: Terraform のインストール処理が正常に終了しました。\033[0m"
}

# AWS CLI uninstall
function aws_cli_uninstall () {
echo -e "\033[1;32mAWS CLI をアンインストールしています…\033[0m"
echo "which aws"
which aws
echo
echo "ls -l /usr/local/bin/aws"
ls -l /usr/local/bin/aws
echo
echo "brew uninstall awscli"
brew uninstall awscli
echo
rm /usr/local/bin/aws ; rm /usr/local/bin/aws_completer ; sudo rm -rf /usr/local/aws-cli
echo
echo -e "\033[1;32mAWS 関連のツールが使用する設定や資格情報を含むディレクトリを削除します。よろしいですか？(y/n)\033[0m"
read confirm

if [ "$confirm" == "y" ]; then
  rm -rf ~/.aws/
  echo ".aws を削除しました。"
else
  echo "削除をキャンセルしました。"
fi
echo
echo -e "\033[1;32mALL SUCCESEFUL: AWS CLI のアンインストール処理が正常に終了しました。\033[0m"
}


# Terraform uninstall
function terraform_uninstall () {
package="hashicorp/tap/terraform"
terraform_d="$HOME/.terraform.d"

echo -e "\033[1;32mTerraform をアンインストールしています…\033[0m"
echo "brew uninstall hashicorp/tap/terraform"
if brew list --formula | grep -q terraform; then
  brew uninstall "$package"
else
  echo -e "\033[1;31mERROR: $package はインストールされていない、またはアンインストール済みです。\033[0m"
fi
echo
sleep 0.5
echo -e "\033[1;32mTerraform 関連ファイルの記述を削除しています…\033[0m"
sleep 0.05
echo "sed -i '' -e '/complete -o nospace -C \/usr\/local\/bin\/terraform terraform/d' ~/.zshrc"
if grep -q 'complete -o nospace -C /usr/local/bin/terraform terraform' ~/.zshrc; then
  sed -i '' -e '/complete -o nospace -C \/usr\/local\/bin\/terraform terraform/d' ~/.zshrc
  echo -e "\033[1;32mSUCCESE: \".zshrc\" から \"complete -o nospace -C \/usr\/local\/bin\/terraform terraform\" を削除しました。\033[0m"
else
  echo -e "\033[1;31mERROR: \".zshrc\" には該当する記述が見つかりませんでした。\033[0m"
fi
sleep 0.05
echo "sed -i '' -e '/complete -C \/usr\/local\/bin\/terraform terraform/d' ~/.bash_profile"
if grep -q 'complete -C /usr/local/bin/terraform terraform' ~/.bash_profile; then
  sed -i '' -e '/complete -C \/usr\/local\/bin\/terraform terraform/d' ~/.bash_profile
  echo -e "\033[1;32mSUCCESE: \".bash_profile\" から \"complete -C /usr\/local\/bin\/terraform terraform\" を削除しました。\033[0m"
else
  echo -e "\033[1;31mERROR: \".bash_profile\" には該当する記述が見つかりませんでした。\033[0m"
fi
echo
echo -e "\033[1;32mTerraform 関連ファイルを削除しています…\033[0m"
sleep 0.05
echo "rm -rf ~/.terraform.d"
if [ -d "$terraform_d" ]; then
  rm -rf "$terraform_d"
  echo -e "\033[1;32mSUCCESE: \".terraform.d\" を削除しました。\033[0m"
  echo
else
  echo -e "\033[1;31mERROR: \".terraform.d\" は既に削除されている、または存在しません。\033[0m"
  echo
  echo -e "\033[1;31mFINISH: Terraform のアンインストール処理を終了しました。\033[0m"
  exit 1
fi
echo -e "\033[1;32mALL SUCCESEFUL: Terraform のアンインストール処理が正常に終了しました。\033[0m"
}

case $1 in
  aws_cli)
    AWS_CLI=aws_cli
  ;;
  terraform)
    Terraform=terraform
  ;;
  *)
    echo -e "\033[1;31mERROR: 指定された引数 $1 は無効です。\033[0m"
    echo -e "\033[1;31mERROR: 指定可能な引数は [ aws_cli | terraform ] です。\033[0m"
    exit 1
  ;;
esac

if [ "$2" = --install ] && [ "$AWS_CLI" ]; then
  aws_cli_install
elif [ "$2" = --uninstall ] && [ "$AWS_CLI" ]; then
  aws_cli_uninstall
elif [ "$2" = --install ] && [ "$Terraform" ]; then
  terraform_install
elif [ "$2" = --uninstall ] && [ "$Terraform" ]; then
  terraform_uninstall
else
  echo -e "\033[1;31mERROR: 指定されたオプション $2 は無効です。\033[0m"
  echo -e "\033[1;31m指定可能なオプションは [ --install | --uninstall ] です。\033[0m"
  exit 1
fi