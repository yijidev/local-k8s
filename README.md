# VirtualBox에서 쿠버네티스 구축하기   
control-plane 1대, node 2대

-Network 설정 : 고정IP 사용

![화면 캡처 2023-12-03 151023](https://github.com/yijidev/local-k8s/assets/119959530/41a8473e-92aa-4987-aa65-992409fdd5ee)


![화면 캡처 2023-12-03 151044](https://github.com/yijidev/local-k8s/assets/119959530/5748193b-192a-4b70-862d-7e72098366ff)


![화면 캡처 2023-12-03 150857](https://github.com/yijidev/local-k8s/assets/119959530/3694edf4-5cec-42ad-94ea-6355be5202c7)


![화면 캡처 2023-12-03 150946](https://github.com/yijidev/local-k8s/assets/119959530/0d85e634-a018-4fa3-9805-5df4a0556922)


![ip주소-2](https://github.com/yijidev/local-k8s/assets/119959530/6ddd535a-0669-4e55-9db0-7a289366d27b)


![ip주소](https://github.com/yijidev/local-k8s/assets/119959530/7b02b18a-0fd2-47ff-8bb7-25b2eb9bc4d6)

- Ubuntu 22.04   
- Kubernetes 1.27.5
- CRI-O 1.27


## Ubuntu 22.04 설치 후 기본 세팅   
- 저장소 업데이트 및 패키지를 최신화    
``` apt update && apt upgrade -y ```   
- openssh-server, curl, vim, tree 설치   
``` apt-get install -y openssh-server curl vim tree ```   
- TimeZone 변경   
``` timedatectl set-timezone 'Asia/Seoul' ```   
- 루트 사용자 패스워드 설정   
``` sudo passwd root ```   
- vm 네트워크 설정   
  - 호스트네임 설정   
``` sudo hostnamectl set-hostname control-plane.example.com ```   
  - 호스트이름 등록   
``` sudo vi /etc/hosts ``` 


    ```
    127.0.0.1 localhost
    192.168.75.100 control-plane.example.com control-plane
    192.168.75.101 node1.example.com node1
    192.168.75.102 node2.example.com node2
    ```   
--------------------------------------   
#### 메모   
- CLI <-> GUI   
  ``` systemctl set-default multi-user.target ``` (CLI)   
  ``` systemctl set-default graphical.target ``` (GUI)   
- 폴더명 한글에서 영문변환   
  ``` export LANG=C ```   
  ``` xdg-user-dirs-gtk-update ```   
- CRI-O, Kubeadm 설치는 루트 사용자에서   
--------------------------------------

## CRI-O 설치   
``` sh crio-install.sh ```   

CRI-O 설치 후 머신 복제   
복제한 머신 각 네트워크 재설정 및 리부팅  
버전으로 인한 에러 참고사항 : https://github.com/cri-o/cri-o/blob/main/install.md#apt-based-operating-systems-1


## 각 노드에 Kubeadm 설치   
``` sh kubeadm-install.sh ```
- kubeadm 설치 확인, kubelet 실행 안 되는 이유는 kubeadm init을 안해서임.   
- 컨트롤 플레인에서   
``` kubeadm init ```
  ``` 
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  ```   
  ``` export KUBECONFIG=/etc/kubernetes/admin.conf ```   
  ```
  kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
  ```   

- 노드에서
  ``` kubeadm join <control-plane-ip>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash <hash> ```

