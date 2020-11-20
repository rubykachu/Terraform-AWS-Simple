# Hướng dẫn sử dụng

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
Ta cần phải khai báo config trong các file `dev.tfvars` hay `prod.tfvars` trước khi thực hiện bước bên dưới

**Lưu ý:** Ta cần phải tạo AMI và coppy ID AMI, gán vào biến `asg_ami_id` trước khi build infra.

```
asg_ami_id = "ami-0f1a5142758f85483"
```

> Bởi vì trong thực tế ta cần phải tạo mẫu 1 EC2, trong EC2 này sẽ setup các package cần thiết mà project cần. Sau đó tạo AMI từ EC2. Ta cần lấy ID AMI để gán vào `asg_ami_id` để Auto Scaling Group sẽ scale ra EC2 theo đúng như ta đã setting lúc ban đầu.

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



