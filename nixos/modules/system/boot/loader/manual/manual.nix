{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.boot.loader.manual;

  manualInstaller = pkgs.writeShellScript "manual-bootloader-installer" ''
    cat <<EOT
    OK, you may update your bootloader now!
    $1
    EOT
  '';
in
{
  options.boot.loader.manual = {
    enable = mkEnableOption "manual configuration of the bootloader";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub.enable = mkDefault false;
      supportsInitrdSecrets = false;
    };

    # FIXME: this means vmWithBootLoader will hang / not work. maybe if
    # `config.virtualisation.useBootLoader` is true, give instructions on how to
    # build a boot disk image for the VM?
    system.build.installBootLoader = manualInstaller;
  };
}
