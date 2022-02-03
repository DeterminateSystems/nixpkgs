#!/bin/sh

set -eux

nix-build ./nixos -A config.system.build.openstackImage --arg configuration "{ imports = [ ./nixos/maintainers/scripts/openstack/openstack-image-zfs.nix ]; }"

boot=$(find ./result/ -name '*.boot.*');
root=$(find ./result/ -name '*.root.*');


echo '`Ctrl-a h` to get help on the monitor';
echo '`Ctrl-a x` to exit';

sleep 1

run_bios() (
  qemu-kvm  "$@"
)

run_efi() (
qemu-kvm \
  -bios /nix/store/raglcndanrfhl27hh38jnqiwfvyvfdpc-OVMF-202108-fd/FV/OVMF.fd \
  "$@"
)

run_efi \
    -nographic \
    -cpu max \
    -m 16G \
    -drive file=$boot,snapshot=on,index=0,media=disk \
    -drive file=$root,snapshot=on,index=1,media=disk \
    -boot c \
    -net user \
    -net nic \
    -msg timestamp=on
