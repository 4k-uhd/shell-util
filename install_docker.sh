#!/bin/bash

# ============================
# Docker & Docker Compose 설치 스크립트
# 아키텍처에 따라 자동으로 설치
# ============================

# 1. 시스템 아키텍처 확인
ARCH=$(uname -m)

echo "🛠️  시스템 아키텍처: $ARCH"

# 2. 패키지 매니저 업데이트
echo "🔄 패키지 업데이트..."
if [ -f /etc/os-release ]; then
    source /etc/os-release
    if [[ "$ID" == "amzn" ]]; then
        sudo yum update -y
    elif [[ "$ID" == "ubuntu" ]]; then
        sudo apt update -y
    else
        echo "❌ 지원하지 않는 OS입니다: $ID"
        exit 1
    fi
else
    echo "❌ OS를 확인할 수 없습니다."
    exit 1
fi

# 3. Docker 설치
echo "🐳 Docker 설치 중..."
if [[ "$ID" == "amzn" ]]; then
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
elif [[ "$ID" == "ubuntu" ]]; then
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Docker 권한 설정
sudo usermod -aG docker $USER

# 4. Docker Compose 설치
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

# 5. 설치 확인
echo "✅ Docker 버전 확인:"
docker --version

echo "✅ Docker Compose 버전 확인:"
docker-compose --version

# 6. Docker 서비스 자동 시작 설정
sudo systemctl enable docker

echo "🎉 Docker와 Docker Compose 설치가 완료되었습니다!"
echo "🔑 변경 사항을 적용하려면 로그아웃 후 다시 로그인하세요."