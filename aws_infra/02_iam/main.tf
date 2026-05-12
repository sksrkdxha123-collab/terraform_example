# 1. EC2 Role (Jenkins & WAS 공용 혹은 Jenkins 전용)
resource "aws_iam_role" "aws11_ec2_role" {
  name = "${var.prefix}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = { 
          Service = "ec2.amazonaws.com" 
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# [필수] SSM 정책 연결: 세션 매니저 접속용
resource "aws_iam_role_policy_attachment" "aws11_ssm_attach" {
  role       = aws_iam_role.aws11_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# [필수] S3 정책 연결: 배포 파일 업로드/다운로드용
resource "aws_iam_role_policy_attachment" "aws11_s3_attach" {
  role       = aws_iam_role.aws11_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# [추가] EC2 관리 권한: 젠킨스가 WAS 인스턴스나 ASG 상태를 조회하기 위해 필요
resource "aws_iam_role_policy_attachment" "aws11_ec2_management" {
  role       = aws_iam_role.aws11_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# 2. EC2 인스턴스 프로파일
resource "aws_iam_instance_profile" "aws11_ec2_instance_profile" {
  name = "${var.prefix}-ec2-instance-profile"
  role = aws_iam_role.aws11_ec2_role.name
}

# 3. CodeDeploy Service Role
resource "aws_iam_role" "aws11_codedeploy_service_role" {
  name = "${var.prefix}-codedeploy-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Principal = { Service = "codedeploy.amazonaws.com" }
        Action = "sts:AssumeRole"
      }]
  })
}

# CodeDeploy Service 정책 연결
resource "aws_iam_role_policy_attachment" "aws11_codedeploy_service_attach" {
  role       = aws_iam_role.aws11_codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}