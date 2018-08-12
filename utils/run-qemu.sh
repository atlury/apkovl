#!/bin/sh
branch=latest-stable
arch=x86_64
repo=http://dl-cdn.alpinelinux.org/alpine/${branch}
flavor=vanilla
overlay="$(readlink -f "$1")"

# TODO: getopt here

kernel=$(mktemp)
initrd=$(mktemp)

wget -O "$kernel" "${repo}/releases/${arch}/netboot/vmlinuz-${flavor}"
wget -O "$initrd" "${repo}/releases/${arch}/netboot/initramfs-${flavor}"

[ -n "$overlay" ] && (
  cd "${overlay%/*}"
  echo "${overlay##*/}" | cpio -H newc -o
) | gzip >> "$initrd"

modloop="${repo}/releases/${arch}/netboot/modloop-${flavor}"
append="console=ttyS0,115200 alpine_repo=${repo}/main modules=loop,squashfs,virtio_net modloop=${modloop} quiet"

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
