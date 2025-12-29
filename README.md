### Github Action + Systemd Initrd 安装NixOS

1. 修改 initrd.nix 中的 /etc/ssh/authorized_keys.d/root 
2. 如果用btrfs，需要添加相应kernel module 和 package
3. kernel module仅有qemu-guest和boot.initrd.includeDefaultModules, 额外硬件自行添加


### Local QEMU Test
以下是macOS上的测试模版供参考
```
  x86_64-test = nixpkgs.legacyPackages.aarch64-darwin.writeShellScriptBin "x86_64-test" ''
    /opt/homebrew/bin/qemu-system-x86_64 -cpu qemu64 -nographic -m 4G \
      -kernel ${self.nixosConfigurations.kexec-x86_64.config.system.build.kernel}/bzImage \
      -initrd ${self.nixosConfigurations.kexec-x86_64.config.system.build.initialRamdisk}/initrd \
      -append "console=ttyS0 systemd.journald.forward_to_console root=fstab" \
      -device "virtio-net-pci,netdev=net0" -netdev "user,id=net0,hostfwd=tcp::8022-:22" \
      -device "virtio-scsi-pci,id=scsi0" -drive "file=disk.img,if=none,format=qcow2,id=drive0" -device "scsi-hd,drive=drive0,bus=scsi0.0" \
  '';

  arm-test = nixpkgs.legacyPackages.aarch64-darwin.writeShellScriptBin "arm-test" ''
    /opt/homebrew/bin/qemu-system-aarch64 -machine virt -cpu host -accel hvf -nographic -m 4G \
      -kernel ${self.nixosConfigurations.kexec-aarch64.config.system.build.kernel}/Image \
      -initrd ${self.nixosConfigurations.kexec-aarch64.config.system.build.initialRamdisk}/initrd \
      -append "systemd.journald.forward_to_console root=fstab" \
      -device "virtio-net-pci,netdev=net0" -netdev "user,id=net0,hostfwd=tcp::8022-:22" \
      -device "virtio-scsi-pci,id=scsi0" -drive "file=disk.img,if=none,format=qcow2,id=drive0" -device "scsi-hd,drive=drive0,bus=scsi0.0" \
      -bios $(ls /opt/homebrew/Cellar/qemu/*/share/qemu/edk2-aarch64-code.fd)
  '';

```



