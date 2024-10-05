# terraform_aws_01

## 概要
- 本構成はTerraformを使用してAWSの各リソースを作成するものである。
- EC2、RDSの設定は含まれていない。
- session managerを使用してEC2へのSSH接続ができることをゴールとしている。
## 構成
![構成](https://github.com/user-attachments/assets/a839ea1a-9050-4631-8a25-d8255ffcddb7)
## IPアドレス
| No.|用途|サブネット|種別|az|備考|
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
|1|ゲートウェイ,ELB|192.168.1.0/24|パブリック|ap-northeast-1a|NATゲートウェイ|
|2|ゲートウェイ,ELB|192.168.2.0/24|パブリック|ap-northeast-1c|NATゲートウェイ|
|3|ゲートウェイ,ELB|192.168.3.0/24|パブリック|ap-northeast-1d|NATゲートウェイ|
|4|サーバ|192.168.4.0/24|プライベート|ap-northeast-1a|
|5|サーバ|192.168.5.0/24|プライベート|ap-northeast-1c|
|6|サーバ|192.168.6.0/24|プライベート|ap-northeast-1d|
|7|RDS|192.168.7.0/24|プライベート|ap-northeast-1a|
|8|RDS|192.168.8.0/24|プライベート|ap-northeast-1c|
|9|RDS|192.168.9.0/24|プライベート|ap-northeast-1d|

## セキュリティグループ
| No.|セキュリティグループ名|アタッチ先|開放ポート|接続元|備考|
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
|1|dev01-web-sg|EC2|80,443|各サーバ|
|2|dev01-mgmt-sg|EC2|22|各サーバ|
|3|dev01-db-sg|RDS|3306|RDS|



