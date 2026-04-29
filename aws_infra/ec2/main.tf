# aws_infra/ec2/main.tf
resource "aws_instance" "aws11_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name
  subnet_id                   = data.aws_subnet.aws11_public_subnet.id
  security_groups = [
    data.aws_security_group.aws11_ssh_sg.id,
    data.aws_security_group.aws11_http_sg.id
  ]
  # CodeDeploy, Agent, Docker 설치
  user_data = <<-EOF
                #!/bin/bash
                # CodeDeploy Agent 설치
                sudo apt update -y
                sudo apt install -y ruby wget
                sudo apt install -y --reinstall ca-certificates
                sudo update-ca-certificates --fresh
                cd /tmp
                wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
                chmod +x install
                ./install auto            
                sudo apt install -y docker.io
                sudo usermod -aG docker ubuntu
                sudo systemctl restart docker
                sudo systemctl enable docker        
                ${file("${path.module}/user_data/docker-install.sh")}        
                EOF
  tags = {
    Name = "${var.prefix}-instance"
  }
}
# 2. CodeDeploy Agent, Docker 설치 대기
resource "null_resource" "aws11_delay" {
  provisioner "local-exec" {
    command = "sleep 180"
  }
  depends_on = [aws_instance.aws11_instance]
}
# 3. 원본 instance를 이용해 AMI 생성
resource "aws_ami_from_instance" "aws11_ami" {
  name               = "${var.prefix}-instance-ami"
  source_instance_id = aws_instance.aws11_instance.id
  snapshot_without_reboot = true
  depends_on         = [null_resource.aws11_delay]
  tags = {
    Name = "${var.prefix}-instance-ami"
  }
}