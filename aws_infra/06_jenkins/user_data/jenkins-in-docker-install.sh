#!/bin/bash
set -e

echo "🐳 컨테이너 내부 Docker CLI 설치를 시작합니다..."

# 1. 기존 불필요한 패키지 제거 및 필수 패키지 설치
apt-get update -y
apt-get install -y ca-certificates curl gnupg

# 2. Docker 공식 GPG 키 등록
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# 3. Docker 데비안 저장소 추가
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4. Docker CLI 및 필수 플러그인만 설치 (데몬은 설치하지 않음)
apt-get update -y
apt-get install -y docker-ce-cli docker-buildx-plugin docker-compose-plugin

# 5. 젠킨스 유저가 도커 소켓에 접근할 수 있도록 권한 부여를 위한 설정
# (실제 권한은 호스트의 /var/run/docker.sock 권한을 따르지만, 바이너리 실행 확인용)
docker --version

echo "✅ 컨테이너 내부 Docker CLI 설치 완료!"