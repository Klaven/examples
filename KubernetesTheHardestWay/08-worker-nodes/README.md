


## install OS deps:
```
sudo apt -y install socat conntrack ipset
```

## disable swap:
```
sudo swapoff -a
```
## make install directories:
```
sudo mkdir -p \
  /etc/cni/net.d \
  /etc/containerd \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes 
```
## Download the stuff
```
wget -q --show-progress --https-only --timestamping \
  https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.15.0/crictl-v1.15.0-linux-amd64.tar.gz \
  https://github.com/opencontainers/runc/releases/download/v1.0.0-rc8/runc.amd64 \
  https://github.com/containernetworking/plugins/releases/download/v0.8.2/cni-plugins-linux-amd64-v0.8.2.tgz \
  https://github.com/containerd/containerd/releases/download/v1.2.9/containerd-1.2.9.linux-amd64.tar.gz \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kube-proxy \
  https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubelet
```

## install binaries
```
  mkdir containerd
  tar -xvf crictl-v1.15.0-linux-amd64.tar.gz
  tar -xvf containerd-1.2.9.linux-amd64.tar.gz -C containerd
  sudo tar -xvf cni-plugins-linux-amd64-v0.8.2.tgz -C /opt/cni/bin/
  sudo mv runc.amd64 runc
  chmod +x crictl kubectl kube-proxy kubelet runc 
  sudo mv crictl kubectl kube-proxy kubelet runc /usr/local/bin/
  sudo mv containerd/bin/* /bin/
```
## Setup networking
update [10-bridge.conf](./10-bridge.conf) with the pods CIDR and move to `/etc/cni/net.d/`

move [99-loopback.conf](./(99-loopback.conf) to `/etc/cni/net.d/`

## Configure container runtime
move [config.toml](./config.toml) to `/etc/containerd/config.toml`

move the service [containerd.service](./containerd.service) into `/etc/systemd/system/contianerd.service`

## Configure Kubelet

```
  sudo mv ../gen/${HOSTNAME}-key.pem ../gen/${HOSTNAME}.pem /var/lib/kubelet/
  sudo mv ../gen/${HOSTNAME}.kubeconfig /var/lib/kubelet/kubeconfig
  sudo mv ../gen/ca.pem /var/lib/kubernetes/
```

update [kubelet-config.yaml](./kubelet-config.yaml) and move into `/var/lib/kubelet/kubelet-config.yaml`

update [kubelet.service](./kubelet.service) and move to `/etc/systemd/system/kubelet.service`

## configure kube-proxy
```
sudo mv ../gen/kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
```

configure [kube-proxy-config.yaml](./kube-proxy-config.yaml) and move too `/var/lib/kube-proxy/kube-proxy-config.yaml`

configure [kube-proxy.service](./kube-proxy.service) and move too `/etc/systemd/system/kube-proxy.service`


## Start EVERYTHING
```
  sudo systemctl daemon-reload
  sudo systemctl enable containerd kubelet kube-proxy
  sudo systemctl start containerd kubelet kube-proxy
```
