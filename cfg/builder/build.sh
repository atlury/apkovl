#!/bin/sh
exec >~/log 2>&1

fail() {
  echo "$1" >&2
  exit 1
}

cd ~ || fail

mkdir .abuild
echo 'PACKAGER_PRIVKEY="/home/anon/.abuild/anon.rsa"' > .abuild/abuild.conf
cp /etc/abuild.key .abuild/anon.rsa
openssl rsa -in .abuild/anon.rsa -pubout > .abuild/anon.rsa.pub

git clone https://github.com/c3d2/aports.git || fail
cd aports/extra || fail

for i in curseofwar sacc; do (cd "$i"; abuild -r); done
