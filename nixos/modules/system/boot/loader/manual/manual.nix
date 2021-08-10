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
  # TODO: boot loader hook and rename option from manual to something more fitting
  options.boot.loader.manual = {
    enable = mkEnableOption "manual configuration of the bootloader";

    installHook = mkOption {
      type = with types; nullOr package;
      default = null;
      description = ''
        A shell script that will be run as part of the bootloader installation process.
        Use <code>writeShellScript</code>, and <code>$1</code> may be used to refer to the output of the system's toplevel.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.loader = {
      grub.enable = mkDefault false;
      systemd-boot.enable = mkDefault false;
      supportsInitrdSecrets = false;
    };

    # FIXME: this means vmWithBootLoader will hang / not work. maybe if
    # `config.virtualisation.useBootLoader` is true, give instructions on how to
    # build a boot disk image for the VM?
    system.build.installBootLoader = if (cfg.installHook != null) then cfg.installHook else manualInstaller;
  };
}
