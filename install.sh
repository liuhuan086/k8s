#!/bin/sh
harbor_path="packages/src/harbor-offline-installer-v2.2.2.tgz"
# 这里的-f参数判断$myFile是否存在
echo "检查$harbor_path 是否存在"
if [ ! -f "$harbor_path" ]; then
echo "$harbor_path 不存在，请手动下载"
exit 1
fi

k8s_path="packages/src/kubernetes-server-linux-amd64-v1.17.2.tar.gz"
# 这里的-f参数判断$myFile是否存在
echo "检查$k8s_path 是否存在"
if [ ! -f "$k8s_path" ]; then
echo "$k8s_path  不存在，请手动下载"
exit 1
fi

s_time=$(date "+%Y-%m-%d %H:%M:%S")
echo "$(date "+%Y-%m-%d %H:%M:%S") 00_init.yml"
ansible-playbook -i hosts ./yml/00_init.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 初始化完成，重启机器中，需要等待一分钟"
sleep 60
echo "$(date "+%Y-%m-%d %H:%M:%S") 机器重启完成"

echo "$(date "+%Y-%m-%d %H:%M:%S") 01_install_bind_docker.yml"
ansible-playbook -i hosts ./yml/01_install_bind_docker.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 02_install_harbor.yml"
ansible-playbook -i hosts ./yml/02_install_harbor.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 04_install_etcd.yml"
ansible-playbook -i hosts ./yml/04_install_etcd.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 05_install_kube_apiserver.yml"
ansible-playbook -i hosts ./yml/05_install_kube_apiserver.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 06_install_master_proxy.yml"
ansible-playbook -i hosts ./yml/06_install_master_proxy.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 07_install_kube_related.yml"
ansible-playbook -i hosts ./yml/07_install_kube_related.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 08_install_kubelet.yml"
ansible-playbook -i hosts ./yml/08_install_kubelet.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 09_install_kube_proxy.yml"
ansible-playbook -i hosts ./yml/09_install_kube_proxy.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 10_check_cluster.yml"
ansible-playbook -i hosts ./yml/10_check_cluster.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 11_install_flannel.yml"
ansible-playbook -i hosts yml/11_install_flannel.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 12_install_CoreDNS.yml"
ansible-playbook -i hosts yml/12_install_CoreDNS.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 13_install_ingress.yml"
ansible-playbook -i hosts yml/13_install_ingress.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 14_install_dashboard.yml"
ansible-playbook -i hosts yml/14_install_dashboard.yml

echo "$(date "+%Y-%m-%d %H:%M:%S") 15_install_hepster.yml"
echo "不建议安装heapster，可以用prometheus来代替，如果需要，可以在命令行单独执行下面一条命令"
#ansible-playbook -i hosts yml/15_install_hepster.yml

e_time=$(date "+%Y-%m-%d %H:%M:%S")

echo "开始时间：${s_time}"
echo "结束时间：${e_time}"
