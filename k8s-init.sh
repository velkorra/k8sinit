#!/bin/bash

set -e

echo "Updating package index..."
sudo apt-get update

echo "Installing prerequisites..."
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

echo "Download the public signing key for the Kubernetes package repositories. The same signing key is used for all repositories so you can disregard the version in the URL:"

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "Add the appropriate Kubernetes apt repository..."

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo "Updating package index..."
sudo apt-get update

echo "Installing kubernetes components..."
sudo apt-get install -y kubelet kubeadm kubectl

echo "Disable auto updates for components..."
sudo apt-mark hold kubelet kubeadm kubectl

echo "enable kubelet"
sudo systemctl enable --now kubelet

echo "Verifying installation..."
kubectl version --client
kubeadm version

