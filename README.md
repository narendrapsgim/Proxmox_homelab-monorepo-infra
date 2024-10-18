# Infra (Home Kubernetes)

My personal Kubernetes cluster configuration using [Infrastructure-as-Code](https://www.redhat.com/en/topics/automation/what-is-infrastructure-as-code-iac) and [GitOps](https://www.weave.works/technologies/gitops/) methodologies.

* Previous version based on Docker inside LXC, without k8s - (https://github.com/narendrapsgim/Proxmox_homelab-monorepo-infra).
* For inspiration, you can look at how others do it - [k8s-at-home](https://github.com/topics/k8s-at-home).
* for reeference owner repository [spirkaa/ansible-homelab] 

## Overview

The main components are divided into directories:

* [ansible](ansible) - roles for configuring VM templates, initial cluster launch using kubeadm, updating Vault secrets.
* [сluster](cluster) - application configuration in the form of Helm charts, kustomize and simple k8s manifests deployed using ArgoCD.
* [packer](packer) - creating VM templates.
* [terraform](terraform) - launch, configuration and lifecycle management of VMs in a cluster.

### Screenshots

| [![01][screenshot-01]][screenshot-01] | [![02][screenshot-02]][screenshot-02] |
| :---:                                 | :---:                                 |
| Dashy                                 | Proxmox                               |
| [![03][screenshot-03]][screenshot-03] | [![04][screenshot-04]][screenshot-04] |
| ArgoCD                                | Vault                                 |
| [![05][screenshot-05]][screenshot-05] | [![06][screenshot-06]][screenshot-06] |
| Gitea                                 | Jenkins                               |
| [![07][screenshot-07]][screenshot-07] | [![08][screenshot-08]][screenshot-08] |
| Longhorn                              | Minio                                 |
| [![09][screenshot-09]][screenshot-09] | [![10][screenshot-10]][screenshot-10] |
| LibreNMS                              | Grafana                               |

[screenshot-01]: https://user-images.githubusercontent.com/2718761/184634976-f7567825-498a-4f3f-9f3f-05ee30aa47f8.png
[screenshot-02]: https://user-images.githubusercontent.com/2718761/184637345-9fd2d9a9-27de-4ca3-8a78-9ea3a391fa5a.png
[screenshot-03]: https://user-images.githubusercontent.com/2718761/184636393-18709d37-35e1-4836-a084-dd04051fbf28.png
[screenshot-04]: https://user-images.githubusercontent.com/2718761/184637717-4ca840a4-85e9-4a30-87a5-be6f5ddeb630.png
[screenshot-05]: https://user-images.githubusercontent.com/2718761/184639944-dce2f6f6-bb93-401f-a869-85087072c12b.png
[screenshot-06]: https://user-images.githubusercontent.com/2718761/184640072-31c8f927-e978-485e-b8ca-c3a27fdadc61.png
[screenshot-07]: https://user-images.githubusercontent.com/2718761/184637197-68ff86a0-3faf-4a41-acad-bc2f5ef098d0.png
[screenshot-08]: https://user-images.githubusercontent.com/2718761/184639800-8ba2028d-f033-4c28-a33a-1ee2592e2c57.png
[screenshot-09]: https://user-images.githubusercontent.com/2718761/184639270-3ced1629-cd55-4bb8-9b72-d6ab41446a7f.png
[screenshot-10]: https://user-images.githubusercontent.com/2718761/184641506-683e7800-baa7-46b0-936c-be4d49cac270.png

### Hardware

The hosts run on [Proxmox](https://www.proxmox.com/en/proxmox-ve) as part of a cluster.

* 1x Custom NAS (Fractal Design Define R6, Corsair RM650x) * Intel Xeon E3-1230 v5 * 64GB DDR4 ECC UDIMM * 1TB NVMe SSD (LVM) * 512GB NVMe SSD (LVM) * 2x 20TB, 3x 18TB HDD ([MergerFS](https://perfectmediaserver.com/tech-stack/ mergerfs/) + [SnapRAID](https://perfectmediaserver.com/tech-stack/snapraid/)) * 2x 12TB HDD (ZFS mirror) * 2x Lenovo IdeaCentre G5-14IMB05 * Intel Core i5-10400 * 32GB DDR4 * 1TB NVMe SSD (LVM) * 512GB NVMe SSD (LVM)
* 1x Ubiquiti EdgeRouter X
* 1x Ubiquiti EdgeSwitch 24 Lite
* 1x CyberPower CP900EPFC

### External services

* DNS - [selectel.ru](https://selectel.ru/services/additional/dns/). Free, has API and webhook for cert-manager.
* VPS - [sale-dedic.com](https://sale-dedic.com/?from=38415).
* Cron execution monitoring - [healthchecks.io](https://healthchecks.io/).
* Service availability monitoring - [uptimerobot.com](https://uptimerobot.com/).
* Certificates - [letsencrypt.org](https://letsencrypt.org/).

## Kubernetes Cluster Components

### Ubuntu 22.04 Virtual Machines

* 3x Control Plane (2 vCPU, 4 GB)
* 3x Worker (4/6 vCPU, 16 GB)
* 2x Control Plane Load Balancer (1 vCPU, 1 GB)

### Base

* [runc](https://github.com/opencontainers/runc)
* [cni](https://github.com/containernetworking/plugins)
* [containerd](https://github.com/containerd/containerd)
* [crictl](https://github.com/kubernetes-sigs/cri-tools)
* [nerdctl](https://github.com/containerd/nerdctl)
* [kubelet, kubeadm, kubectl](https://github.com/kubernetes/kubernetes)

### Network
* [Calico](https://github.com/projectcalico/calico)
* [MetalLB](https://github.com/metallb/metallb)
* [ingress-nginx](https://github.com/kubernetes/ingress-nginx
*  [cert-manager](https://github.com/cert-man ager/cert-manager) + [cert-manager-webhook-selectel](https://github.com/selectel/cert-manager-webhook-selectel)
*  [Keepalived](https://www.keepalived.org) + [HAProxy](https://www.haproxy.com) outside the cluster for Control Plane
*  [consul](https://github.com/hashicorp/consul) ### Storage * [Longhorn](https://github.com/longhorn/longhorn)
*   [minio](https://github.com/minio/minio)
*    NFS

 ### Observability (logs, metrics, traces, alerts)
  * [kube-prometheus-stack](https://github.com/prometheus-community/helm -charts)
  *  [Prometheus](https://github.com/prometheus/prometheus)
  *   [Alertmanager](https://github.com/prometheus/alertmanager)
  *   [Grafana](https://github.com/grafana/grafana)
  *   [Blackbox Exporter](https://github.com/prometheus/blackbox_exporter)
  *    [Thanos](https://github.com/thanos-io/thanos)
  *    [Loki](https://github.com/grafana/loki)
  *    [Promtail](https://grafana.com/docs/loki/latest/clients/promtail/)
  *    [metrics-server](https://github.com/kubernetes-sigs/metrics-server)
  *    [karma](https://github.com/prymitive/karma)
  *    [signoz](https://github.com/SigNoz/signoz)
  
 ### CI/CD, GitOps
  *    [signoz](https://github.com/SigNoz/signoz)
  *    [ArgoCD](https://github.com/argoproj/argo-cd) + [argocd-vault-plugin](https://github.com/argoproj-labs/argocd-vault-plugin)
  *    [Renovate](https://github.com/renovatebot/renovate)
  *    [gitlab-runner](https://gitlab.com/gitlab-org/charts/gitlab-runner)
  *    [jenkins k8s agent](https://github.com/jenkinsci/jenkins )
### Secrets 

  *    [Vault](https://github.com/hashicorp/vault) + [vault-bootstrap](https://github.com/spirkaa/vault-bootstrap)
  *    [external-secrets](https://github.com/external-secrets/external-secrets/)
    
### Auth 

  *    [dex](https://github.com/dexidp/dex)
  *    [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy)
  *  [teleport](https://github.com/gravitational/teleport)
    
### Backup

  *    [velero](https://github.com/vmware-tanzu/velero) 
    
### Utilities
  *  [signoz](https://github.com/SigNoz/signoz)
  *  [descheduler](https ://github.com/kubernetes-sigs/descheduler)
  *  [kured](https://github.com/kubereboot/kured)
  *  [Reloader](https://github.com/stakater/Reloader)
  *  [kubernetes-event-exporter](https://github.com/resmoio/kubernetes-event-exporter)
  *  [Vertical Pod Autoscaler](https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler)
  *  [Goldilocks](https://github.com/FairwindsOps/goldilocks)

## Payloads (user applications)

### My developments

* [gia-api](https://github.com/spirkaa/gia-api)
* [samgrabby](https://github.com/spirkaa/samgrabby)
* [devmem.ru](https://github.com/spirkaa/devmem.ru)

### Private cloud

* [Nextcloud](https://github.com/nextcloud/server)
* [Syncthing](https://github.com/syncthing/syncthing)
* [docker-mailserver](https://github.com/docker-mailserver/docker-mailserver) * [Vaultwarden](https://github.com/dani-garcia/vaultwarden)

### Media-saver

* [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr)
* [Bazarr](https://github.com/morpheus65535/bazarr)
* [Radarr](https://github.com/Radarr/Radarr)
* [Sonarr](https://github.com/Sonarr/Sonarr)
* [Lidarr](https://github.com/lidarr/Lidarr)
* [Prowlarr](https://github.com/Prowlarr/Prowlarr)
* [Jackett](https://github.com/Jackett/Jackett)
* [Monitorrent](https://github.com/werwolfby/monitorrent)
* [Deluge](https://github.com/binhex/arch-delugevpn)
* [Tautulli](https://github.com/Tautulli/Tautulli)
* [Ombi](https://github.com/Ombi-app/Ombi)

  
### Management
* [Dashy](https://github.com/lissy93/dashy)
* [Portainer] (https://github.com/portainer/portainer)
* [UniFi Network](https://help.ui.com/hc/en-us/categories/200320654)

## Starting a cluster

### Requirements

* Proxmox server
* Linux client with `git` and `docker` installed to run container with utilities

### Launch algorithm

1. Clone repository

`git clone --recurse-submodules https://github.com/narendrapsgim/Proxmox_homelab-monorepo-infra`

2. Go to directory

`cd infra`

3. Copy env file

`cp .env.example .env`

4. Specify required values ​​in env file

`nano .env`

5. Check/change variable values

    * ansible/roles/\**/**/defaults/main.yml
    * [packer/variables.pkr.hcl](packer/variables.pkr.hcl)
    * [terraform/locals.tf](terraform/locals.tf)

6. Build an image with utilities and run the container

`make tools`

7. Run cluster deployment

`make cluster`

After launch, the following steps are performed automatically:

| | Description | Tools |
| :-: | - | - |
| 8 | Create a user for the Proxmox API | Ansible |
| 9 | Prepare VM templates | Packer, Ansible |
| 10 | Create VM from templates, deploy cluster | Terraform, Ansible |
| 11 | Deploy applications to cluster | ArgoCD |

## User for Packer and Terraform access to Proxmox API

You can create a user using the [pve/api_user](ansible/roles/pve/api_user) role or manually by running commands in the Proxmox server console and saving the output of the latter. **Additional rights not specified in the provider documentation have been assigned to work with the Proxmox cluster [telmate/proxmox](https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md#creating-the-proxmox-user-and-role-for-terraform)**

`pveum role add Provisioner -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Pool.Audit Sys.Audit Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Console VM.Monitor VM.PowerMgmt"`

`pveum user add hashicorp@pve`

`pveum aclmod / -user hashicorp@pve -role Provisioner`

`pveum user token add hashicorp@pve packer-terraform --privsep 0`

## Basic VM template (cloud-init)

Preparation is performed in 2 stages:

1. [Ansible](https://www.ansible.com/) downloads the [Ubuntu Cloud](https://cloud-images.ubuntu.com/releases/jammy/) image, installs the `qemu-guest-agent` package into the image using `virt-customize` and resets the `machine-id`, creates the VM in Proxmox and imports the image (but does not start it), converts the VM into a template. The finished template must remain in the system for idempotency.
2. [Packer](https://www.packer.io/) clones the template from step 1, starts the VM, configures it using Ansible, converts it to a template.

Deploying the VM from the template is done using [Terraform](https://www.terraform.io/).

## Shutdown/reboot node

1. Remove load

```bash
kubectl drain k8s-worker-01 --ignore-daemonsets --delete-emptydir-data --pod-selector='app!=csi-attacher,app!=csi-provisioner'
```

2. Configure notification stub in Alertmanager

3. After enabling, allow load

```bash
kubectl uncordon k8s-worker-01
```

## Replace node

1. Remove load

```bash
kubectl drain k8s-controlplane-02 --ignore-daemonsets --delete-emptydir-data --pod-selector='app!=csi-attacher,app!=csi-provisioner'
```

2. Remove from k8s

```bash
kubectl delete node k8s-controlplane-02
```

3. Remove etcd from cluster (for control plane)

Get list and copy needed <MEMBER_ID>

```bash
kubectl -n kube-system exec -it etcd-k8s-controlplane-04 -- sh -c 'ETCDCTL_API=3 etcdctl --cacert="/etc/kubernetes/pki/etcd/ca.crt" --cert="/etc/kubernetes/pki/etcd/server.crt" --key="/etc/kubernetes/pki/etcd/server.key" member list -w table'
```

Delete member <MEMBER_ID>

```bash
kubectl -n kube-system exec -it etcd-k8s-controlplane-04 -- sh -c 'ETCDCTL_API=3 etcdctl --cacert="/etc/kubernetes/pki/etcd/ca.crt" --cert="/etc/kubernetes/pki/etcd/server.crt" --key="/etc/kubernetes/pki/etcd/server.key" member remove <MEMBER_ID>'
```

4. Remove and add node via Terraform

## etcd defragmentation

<https://etcd.io/docs/v3.5/op-guide/maintenance/#defragmentation>

```bash
kubectl -n kube-system exec -it etcd-k8s-controlplane-04 -- sh -c 'ETCDCTL_API=3 etcdctl --cacert="/etc/kubernetes/pki/etcd/ca.crt" --cert="/etc/kubernetes/pki/etcd/server.crt" --key="/etc/kubernetes/pki/etcd/server.key" defrag --cluster' ```
