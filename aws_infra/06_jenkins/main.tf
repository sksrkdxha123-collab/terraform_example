resource "aws_instance" "aws11_jenkins_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  
  # network 모듈에서 생성한 NAT 게이트웨이와 연결된 Private Subnet 1번 사용
  subnet_id              = data.aws_subnets.aws11_private_subnets.ids[0]
  
  # 프라이빗 망이므로 퍼블릭 IP는 할당하지 않음
  associate_public_ip_address = false

  vpc_security_group_ids = [
    data.aws_security_group.aws11_ssh_sg.id, 
    data.aws_security_group.aws11_http_sg.id
  ]
  
  # data.tf (33번 라인 부근)에 정의된 인스턴스 프로파일 참조
  iam_instance_profile = data.aws_iam_instance_profile.aws11_ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # NAT 게이트웨이를 통해 외부와 통신하여 SSM 에이전트 활성화
              sudo systemctl enable amazon-ssm-agent
              sudo systemctl start amazon-ssm-agent

              # 1. 호스트 OS용 Docker 설치
              ${file("${path.module}/user_data/install-docker.sh")}

              # 2. 작업 디렉토리 생성 및 파일 배치
              mkdir -p /home/ubuntu/jenkins-setup/jenkins_home
              cd /home/ubuntu/jenkins-setup

              cat <<'EOT' > Dockerfile
              ${file("${path.module}/user_data/Dockerfile")}
              EOT

              cat <<'EOT' > install-awscli.sh
              ${file("${path.module}/user_data/install-awscli.sh")}
              EOT

              cat <<'EOT' > jenkins-in-docker-install.sh
              ${file("${path.module}/user_data/jenkins-in-docker-install.sh")}
              EOT

              cat <<'EOT' > docker-compose.yml
              ${file("${path.module}/user_data/docker-compose.yaml")}
              EOT

              # 3. 권한 설정
              sudo chown -R 1000:1000 /home/ubuntu/jenkins-setup/jenkins_home

              # 4. 즉시 도커 그룹 권한 적용하여 빌드 및 실행
              cd /home/ubuntu/jenkins-setup
              sudo -u ubuntu sg docker -c "docker compose up -d --build"
              EOF

  tags = { Name = "${var.prefix}-jenkins-server" }
}

# ALB 대상 그룹에 프라이빗 젠킨스 인스턴스 연결
resource "aws_lb_target_group_attachment" "aws11_jenkins_attach" {
  target_group_arn = data.aws_lb_target_group.aws11_jenkins_tg.arn
  target_id        = aws_instance.aws11_jenkins_server.id
  port             = 80
}