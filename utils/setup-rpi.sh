#!/bin/sh
apkovl=""

fail() {
  echo "$1" >&2
  exit 1
}

while [ -n "$1" ]; do
  case "$1" in
  -o)
    apkovl="$(readlink -f "$2")"
    shift
    ;;
  --)
    break
    ;;
  -*)
    fail "Unknown option $1"
    ;;
  *)
    break
    ;;
  esac
  shift
done

device="$1"

[ -n "$device" ] || fail "No device specified"

(
  echo o # create a new empty DOS partition table

  echo n # add a new partition
    echo p # primary partition
    echo 1 # partition number
    echo 1 # first cylinder
    echo +128M # size 128M

  echo t # change a partition's system id
    echo c # Win95 FAT32 (LBA)

  echo a # toggle a bootable flag
    echo 1 # ... of partition 1

  echo w # write table to disk and exit

) | fdisk "$device"

case "$(stat -c "%F" "$device")" in
'block special file')
  part=${device}1
  [ -e "$part" ] || fail "Partition not found!"
  ;;
*)
  fail "$device is not an block device!"
  ;;
esac

mkfs.vfat "$part" || fail "Unable to create FAT partition"
mountpoint=$(mktemp -d)
[ -n "$mountpoint" ] || fail "Failed to create mountpoint"
mount -t vfat "$part" "$mountpoint" || fail "Unable to mount partition"

(
  cd "$mountpoint" || fail "Unable to use mountpoint"
  curl -s http://dl-cdn.alpinelinux.org/alpine/v3.8/releases/armhf/alpine-rpi-3.8.0-armhf.tar.gz | tar -xvz --no-same-owner

  [ -e "start.elf" ] || fail "Failed to extract tarball"

  # See bug #7024
  echo "enable_uart=1" >> usercfg.txt

  if [ -n "$apkovl" ]; then
    rm *.apkovl.tar.gz
    cp "$apkovl" .
  fi
) || fail "Unable to install files"

umount "$mountpoint" || fail "Unable to umount partition"
rm -rf "$mountpoint"
