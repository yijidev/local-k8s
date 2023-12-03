#!/bin/bash
#CRI-O 설치를 위한 필수 구성 요소 설치 및 구성
echo "..................................... .conf 파일을 만들어 부팅시 모듈을 로드"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

echo "..................................... 필요한 sysctl 매개 변수를 설정하면 재부팅 후에도 유지"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

echo "..................................... 재부팅 없이 sysctl 매개변수 적용"
sysctl --system

export OS=xUbuntu_22.04
export VERSION=1.27

echo "..................................... 저장소 추가"

echo "deb [signed-by=/usr/share/keyrings/libcontainers-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb [signed-by=/usr/share/keyrings/libcontainers-crio-archive-keyring.gpg] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$VERSION.list

mkdir -p /usr/share/keyrings
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-archive-keyring.gpg
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$VERSION/$OS/Release.key | gpg --dearmor -o /usr/share/keyrings/libcontainers-crio-archive-keyring.gpg

echo ".....................................  패키지 색인 업데이트 및 CRI-O 설치"
apt update
apt install cri-o cri-o-runc

echo "..................................... CRI-O 활성화 및 시작"
systemctl daemon-reload
systemctl enable crio --now
