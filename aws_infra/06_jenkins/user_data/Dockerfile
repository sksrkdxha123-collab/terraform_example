FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y git curl sudo unzip

# 파일 복사 (main.tf에서 이 이름으로 생성됨)
COPY install-awscli.sh install-awscli.sh
COPY jenkins-in-docker-install.sh jenkins-in-docker-install.sh

# 실행 권한 부여 및 설치
RUN chmod +x install-awscli.sh && ./install-awscli.sh
RUN chmod +x jenkins-in-docker-install.sh && ./jenkins-in-docker-install.sh

USER jenkins