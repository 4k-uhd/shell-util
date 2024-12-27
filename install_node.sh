#!/bin/bash

# 1. 패키지 업데이트 및 필요한 패키지 설치
sudo apt update -y
sudo apt install -y curl wget gnupg2 ca-certificates

# 2. Nginx 설치
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# 3. NVM 설치
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# NVM 설정 적용 (현재 세션)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# NVM 설정 적용 (/home/ubuntu/.bashrc 에 반영)
echo "" >> /home/ubuntu/.bashrc
echo 'export NVM_DIR="$HOME/.nvm"' >> /home/ubuntu/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/ubuntu/.bashrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /home/ubuntu/.bashrc

# 4. Node 18 LTS 설치
nvm install 18
nvm use 18
nvm alias default 18

# 5. PM2 글로벌 설치
npm install -g pm2

# 6. Yarn 글로벌 설치
npm install -g yarn

# 설치 완료 메시지 출력
echo "========================================"
echo "      설치가 완료되었습니다.        "
echo "========================================"
echo "Nginx, NVM, Node 18 LTS, PM2, Yarn"
echo "========================================"