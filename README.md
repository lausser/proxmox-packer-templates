# proxmox-packer-templates

This repository is used to create Proxmox templates.

### Prerequisites
The (external) ip address of the system using this repository.
Packer simply takes the address of the first non-loopback interface which might not be reachable from the packer vm.

Packer creates a (sudo-) user named "packer" in the template. It's password is in the environment variable PACKER_PASS. (It must be the same password which is set in the autoinstaller files)
In order to communicate with the Proxmox cluster, we use the user packer@pve. It's password is set in the environment variable PM_PASS.

```bash
export PACKER_IP=$(ip route get 1 | awk '{print $NF;exit}')
export PACKER_PASS=....
export PM_PASS=....
```

### Building a template
The build process can either be run with a local packer command or using the hashicorp/packer container.

```bash
docker run --net=host \
    -e PACKER_LOG=9 \
    -e PACKER_PASS="$PACKER_PASS" \
    -e PM_USER=packer@pve \
    -e PM_PASS="$PM_PASS" \
    -e PM_API_URL=https://10.0.13.13:8006/api2/json \
    --rm -it \
    -v `pwd`/http:/http \
    -v `pwd`/templates:/templates \
    -v `pwd`/variables:/variables \
    -v `pwd`/scripts:/scripts \
    -v `pwd`/ansible:/ansible \
    lausser/packsible build \
    -var-file=/variables/proxmox.json \
    -var-file=/variables/login.json \
    -var-file=/variables/hw-sizing.json \
    -var-file=/variables/centos-8.1.json \
    -var headless=false \
    -var packer_ip="$PACKER_IP" \
    /templates/generic.json
```

### Preparation of the autoinstall files
Every preseed/kickstart/autoinst file must make sure that a user named packer is created.
Password hashes (from the password in $PACKER_PASS) can be created with the following commands:

#### sha512 ($6$...)
```bash
echo 'import crypt,getpass; print crypt.crypt(getpass.getpass(), "$6$alekshdifoanelf8")' | python -
$6$....
```

### bcrypt ($2y$...)
```bash
htpasswd -bnBC 10 "" <passwort> |  tr -d ':\n'
```
