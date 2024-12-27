#!/bin/bash

# ============================
# Ubuntu Docker & Docker Compose 설치 스크립트
# ============================

# 1. 시스템 정보 확인
ARCH=$(uname -m)
echo "🛠️  시스템 아키텍처: $ARCH"

# 2. 패키지 매니저 업데이트 및 필수 패키지 설치
echo "🔄 패키지 업데이트 및 필수 패키지 설치..."
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# 3. Docker GPG 키 추가 및 레포지토리 설정
echo "🔑 Docker GPG 키 추가 및 레포지토리 설정..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4. Docker 설치
echo "🐳 Docker 설치 중..."
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker 권한 설정
echo "👤 현재 사용자를 Docker 그룹에 추가..."
sudo usermod -aG docker $USER

# Docker 서비스 시작 및 자동 시작 활성화
sudo systemctl start docker
sudo systemctl enable docker

# 5. Docker Compose 설치
echo "🐙 Docker Compose 설치 중..."
DOCKER_COMPOSE_VERSION="2.29.0"

if [[ "$ARCH" == "x86_64" ]]; then
    sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
elif [[ "$ARCH" == "aarch64" ]]; then
    sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-aarch64" -o /usr/local/bin/docker-compose
else
    echo "❌ 지원하지 않는 아키텍처입니다: $ARCH"
    exit 1
fi

sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# 6. 설치 확인
echo "✅ Docker 버전 확인:"
docker --version

echo "✅ Docker Compose 버전 확인:"
docker-compose --version

# 7. Docker 서비스 자동 시작 설정
sudo systemctl enable docker

echo "🎉 Docker와 Docker Compose 설치가 완료되었습니다!"
echo "🔑 변경 사항을 적용하려면 로그아웃 후 다시 로그인하세요."