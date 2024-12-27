#!/bin/bash

# ================================
# EC2 루트 파티션 자동 확장 스크립트
# 지원 파일시스템: ext4, xfs
# ================================

# 1. 루트 파티션 확인
ROOT_PARTITION=$(lsblk -no PKNAME $(df / | tail -1 | awk '{print $1}'))
PARTITION=$(df / | tail -1 | awk '{print $1}')
FILESYSTEM=$(df -T / | tail -1 | awk '{print $2}')

echo "🛠️  루트 디스크: $ROOT_PARTITION"
echo "🛠️  루트 파티션: $PARTITION"
echo "🛠️  파일 시스템: $FILESYSTEM"

# 2. growpart 실행 (파티션 확장)
echo "🔄 파티션 확장 중..."
sudo growpart /dev/$ROOT_PARTITION 1

# 3. 파일 시스템 확장
if [[ "$FILESYSTEM" == "ext4" ]]; then
    echo "🔄 ext4 파일 시스템 확장 중..."
    sudo resize2fs /dev/${ROOT_PARTITION}1
elif [[ "$FILESYSTEM" == "xfs" ]]; then
    echo "🔄 xfs 파일 시스템 확장 중..."
    sudo xfs_growfs /
else
    echo "❌ 지원하지 않는 파일 시스템입니다: $FILESYSTEM"
    exit 1
fi

# 4. 확장 확인
echo "✅ 확장 완료! 현재 디스크 상태:"
df -h /