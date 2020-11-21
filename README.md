# Overview
![image](https://user-images.githubusercontent.com/26104119/99877819-6d155180-2c33-11eb-8cc9-2e161552de02.png)

Build infrastructure AWS Failover and High Availability

# I. Setup môi trường

## 1. Install Terraform for MacOs
Document: https://learn.hashicorp.com/tutorials/terraform/install-cli

```
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
$ terraform -install-autocomplete
```

## 2. Install AWS for MacOs
Document: https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html

1/ Tải package về máy
2/ Click double vào package và cài đặt. Nên cài vào disk local
3/ Kiểm tra sau khi cài đặt

```
$ which aws
/usr/local/bin/aws

$ aws --version
aws-cli/2.1.1 Python/3.7.4 Darwin/19.6.0 exe/x86_64
```

## 3. Configure AWS
Documents: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html

```
$ aws configure --profile [name]

AWS Access Key ID [None]:
AWS Access Key ID [None]:
Default region name [None]:
Default output format [None]:
```

Kiểm tra credentials vừa setting `cat  ~/.aws/credentials`

**Cách sử dụng:**
```
$ aws ec2 [action] --profile [name_profile]
```
Ví dụ muốn list tất cả EC2:

`aws ec2 describe-instances --profile learning`

Ngoài ra, ta củng có thể set ENV trong 1 session để không cần gõ --profile
```
$ export AWS_PROFILE=[name_profile]
```
Và thử lại ví dụ trên `aws ec2 describe-instances` vẫn cho ra kết quả tương tự.

# II. Starting Build AWS

Clone project về máy và làm theo các step bên dưới.

## 1. Tạo workspace
Workspace dùng để chia môi trường dev, staging, product. Ở đây ta tạo workspace chỉ để log lại trạng thái của các môi trường. Còn config các môi trường ở trong các file `dev.tfvars`, `prod.tfvars`

```
# Tạo workspace
$ terraform workspace new [name]

# Hiển thị các workspace đang có
$ terraform workspace list

# Chọn workspace
$ terraform workspace select [name]

# Kiểm tra workspace hiện tại là cái nào
$ terraform workspace show
```

Sau khi tạo workspace và select 1 workspace xong thì ta tiến hành build terraform

## 2. Tạo ssh-keygen
Để SSH lên EC2 thì phải cần keypair. Vậy thay vì ta phải lên dashboard AWS để tạo thì ta có thể tạo ở local và push lên AWS thông qua Terraform.

__Có thể tạo ra các keypair cho từng môi trường khác nhau.__

```
$ ssh-keygen -f terraform_ec2_key
```

Sau khi run command trên thì tạo ra 2 file `terraform_ec2_key` và `terraform_ec2_key.pub`.
Copy nội dung ssh-rsa trong file `.pub` và gán vào biến `keypair` trong file `*.tfvars`.
File còn lại tuyệt đối phải bảo mật và giữ lại ở local dùng để ssh lên EC2

Ta chỉ cần setting như sau vào file `dev.tfvars`, `prod.tfvars`

```
keypair = {
  name = "MKP-exm-dev"
  value = "ssh-rsa AAAAB3...bQ5H3M= apple@MinhTangs-MBP"
}
```

## 3. Thiết lập file config theo môi trường
Ta cần phải khai báo config trong các file `dev.tfvars` hay `prod.tfvars` trước khi thực hiện.

**Lưu ý: Trước khi build infra bằng terraform**

1. Gán tên profile. Run command `cat  ~/.aws/credentials` để xem tên profile

```
profile = "learning"
```

2. Gán ID của AMI

```
asg_ami_id = "ami-0f1a5142758f85483"
```

Để có được ID của AMI ta cần phải tạo sẵn 1 EC2 và sau đó `create new image`

> _Vì sao phải tạo AMI trước:
Bởi vì trong thực tế ta cần phải tạo mẫu một EC2, trong EC2 này sẽ setup các package cần thiết mà project cần. Sau đó tạo AMI từ EC2. Ta cần lấy ID AMI để gán vào `asg_ami_id` để Auto Scaling Group sẽ scale ra EC2 theo đúng như ta đã setting lúc ban đầu._

## 4. Build infra aws via terraform
```
$ terraform init
$ terraform workspace select [dev]
```

Nếu ta muốn build infra aws cho môi trường nào thì chỉ định thông qua `-var-file=[env].tfvars`

```
$ terraform apply -var-file=dev.tfvars -auto-approve [-lock=false]
```

Sau khi `apply` thì terraform sẽ tự động build môi trường trên AWS.

**Lưu ý**: Trong terraform không có cơ chế Rollback. Nếu lỗi bước nào thì sẽ dừng tại bước đó, và các bước đã chạy thì vẫn tồn tại các resources trên AWS.

## Others

**Destroy**

Nếu muốn xóa 1 `module` hay `resource` đã build trước đó thì cần chỉ định thông qua `-target=`

```
$ terraform destroy -target=[resource-or-module] -var-file=dev.tfvars -auto-approve [-lock=false]
```

Xóa tất cả những thứ đã build trên AWS từ Terraform (Không nên dùng lệnh này trong thực tế)

```
$ terraform destroy -var-file=dev.tfvars -auto-approve [-lock=false]
```

**Access to console terraform**

```
$ terraform console
```

**Hiển thị chi tiết config terraform theo workspace hiện tại**

```
$ terraform show
```

hoặc

```
$ terraform plan -var-file=dev.tfvars -lock=false
```

Đối với `show` thì terraform sẽ dựa vào config hiện tại để show ra mà không cần gọi API AWS. Ngược lại với `plan` thì sẽ gọi API AWS để kiểm tra và cho ra kết quả chính xác hơn (nếu có lỗi thì sẽ báo lỗi, còn show thì không)
