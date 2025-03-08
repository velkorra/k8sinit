#!/bin/bash

set -e

echo "Starting Kubernetes cleanup..."

echo "Removing package holds..."
sudo apt-mark unhold kubelet kubeadm kubectl

echo "Removing Kubernetes packages..."
sudo apt-get remove -y --purge kubelet kubeadm kubectl
sudo apt-get autoremove -y

echo "Removing Kubernetes configuration files..."
sudo rm -rf /etc/kubernetes/
sudo rm -rf $HOME/.kube/

echo "Removing Kubernetes apt repository..."
sudo rm -f /etc/apt/sources.list.d/kubernetes.list
sudo rm -f /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Disabling and stopping kubelet service..."
sudo systemctl stop kubelet || true
sudo systemctl disable kubelet || true

echo "Cleaning up network configurations..."
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -X

echo "Removing additional artifact directories..."
sudo rm -rf /var/lib/kubelet/
sudo rm -rf /var/lib/etcd/
sudo rm -rf /run/kubernetes/

echo "Updating package index..."
sudo apt-get update

echo "Kubernetes cleanup completed. The system has been restored to pre-installation state."