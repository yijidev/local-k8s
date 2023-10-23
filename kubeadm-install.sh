#!/bin/bash

echo "..................................... 스왑 비활성화"
swapoff -a

echo "..................................... apt 패키지 색인 업데이트, k8s apt repo 패키지 설치"
apt-get update
apt-get install -y apt-transport-https ca-certificates

echo "..................................... 공개 사이닝 키 다운로드"
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://dl.k8s.io/apt/doc/apt-key.gpg
sleep 30s

echo "..................................... 쿠버네티스 apt repo 추가"
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "..................................... apt 패키지 색인 업데이트, k 설치 및 해당 버전 고정"
apt-get update
apt-get install -y kubelet=1.27.5-00 kubeadm=1.27.5-00 kubectl=1.27.5-00
apt-mark hold kubelet kubeadm kubectl

echo "..................................... Restart kubelet"
systemctl daemon-reload
systemctl restart kubelet

apt-get update

echo "..................................... Excute successfully"