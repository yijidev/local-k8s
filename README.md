# local-k8s

오늘 한 것
https://devopsforu.com/how-to-install-kubernetes-1-27/
여기보고 쿠버네티스 1.27.5 구성하기

이중에서 쿠버네티스 설치는
sudo apt-get update -q && sudo apt-get install -qy kubelet=1.27.5-00 kubeadm=1.27.5-00 kubectl=1.27.5-00
(지우기는 sudo apt-get purge kubeadm kubelet kubectl)

그리고 워커노드에서 crio 전부 다시 다운받고
sudo kubeadm join 함

회고) vm 복사하기 전에, docker를 설치하는게 아니라 cri-o를 설치하고 복제를 했어야함
cri-o 버전이 1.25 같던데..
이건 괜찮은지 모르겠음. 확인필요함

=>
$crio version 하면 1.25.4 나옴
개인적으로...

스크립트로 작성해서 설치하는건 어떨까 싶음.
ansible은 나중에.
그리고 프엔해야하는데
