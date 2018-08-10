#!/bin/sh
branch=latest-stable
arch=x86_64
repo=http://dl-cdn.alpinelinux.org/alpine/${branch}/main
flavor=vanilla
overlay="$(readlink -f "$1")"

# TODO: getopt here

kernel=$(mktemp)
initrd=$(mktemp)

wget -O "$kernel" "http://boot.alpinelinux.org/images/${branch}/${arch}/vmlinuz-${flavor}"
wget -O "$initrd" "http://boot.alpinelinux.org/images/${branch}/${arch}/initramfs-${flavor}"

[ -n "$overlay" ] && (
  cd "${overlay%/*}"
  echo "${overlay##*/}" | cpio -H newc -o
) | gzip >> "$initrd"

modloop="http://boot.alpinelinux.org/images/${branch}/${arch}/modloop-${flavor}"
append="console=ttyS0,115200 alpine_repo=${repo} modules=loop,squashfs,virtio_net modloop=${modloop} quiet"

if [ -n "$overlay" ]; then
  append="$append apkovl=/${overlay##*/}"
fi

qemu-system-x86_64 -m 1024 -boot n -enable-kvm \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0 \
  -serial stdio \
  -kernel "$kernel" \
  -initrd "$initrd" \
  -append "$append"

rm "$kernel" "$initrd"
