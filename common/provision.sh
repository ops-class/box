#!/bin/sh -e

APT_FLAGS="-qq -y -o pkg::Use-Pty=0 -o pkg::Options::='--force-confdef' -o pkg::Options::='--force-confold'"
export DEBIAN_FRONTEND=noninteractive

apt-get $APT_FLAGS update
apt-get $APT_FLAGS install software-properties-common locate tmux bash-completion man lsof iotop dos2unix
add-apt-repository ppa:ops-class/os161-toolchain 2>&1 || true
add-apt-repository ppa:git-core/ppa 2>&1 || true
apt-get $APT_FLAGS update
apt-get $APT_FLAGS dist-upgrade
apt-get $APT_FLAGS install os161-toolchain git git-doc

# 24 Dec 2015 : GWA : Bootstrap trinity user.
if ! id -u trinity > /dev/null 2>&1 ; then
  useradd trinity -u 10000 -m -s /bin/bash 
  rsync -a /etc/skel/ /home/trinity/

  mkdir /home/trinity/.ssh
  cp /home/vagrant/.ssh/authorized_keys /home/trinity/.ssh/
  chmod 0700 /home/trinity/.ssh

  echo "trinity ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/trinity

  touch /home/trinity/.hushlogin
  mv /tmp/bashrc /home/trinity/.bashrc
  dos2unix /home/trinity/.bashrc 2>&1
  chown trinity:trinity -R /home/trinity/

  # 24 Dec 2015 : GWA : Try to speed up SSH. Doesn't help much.
  echo >> /etc/ssh/sshd_config
  echo "UseDNS no" >> /etc/ssh/sshd_config
  echo "GSSAPIAuthentication no" >> /etc/ssh/sshd_config
  service ssh reload

  echo "America/New_York" > /etc/timezone
  dpkg-reconfigure tzdata 2>&1
fi

apt-get $APT_FLAGS autoremove --purge
apt-get $APT_FLAGS clean
dd if=/dev/zero of=/EMPTY bs=1M 2>/dev/null || true
rm -f /EMPTY
reboot

# vim: ts=2:sw=2:et:ft=sh
