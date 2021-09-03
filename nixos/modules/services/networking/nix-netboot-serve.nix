{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nix-netboot-serve;
in
{
  options = {
    services.nix-netboot-serve = {
      enable = mkEnableOption "nix-netboot-serve";

      gcRootsDir = mkOption {
        type = types.path;
        default = "./gc-roots";
        description = "todo";
      };

      configDir = mkOption {
        type = types.path;
        default = "./configurations";
        description = "todo";
      };

      profileDir = mkOption {
        type = types.path;
        default = "./profiles";
        description = "todo";
      };

      cpioCacheDir = mkOption {
        type = types.path;
        default = "./cpio-cache";
        description = "todo";
      };

      bindAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "todo";
      };

      port = mkOption {
        type = types.int;
        default = 3030;
        description = "todo";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nix-netboot-serve = {
      description = "nix-netboot-serve";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      # path = [ config.nix.package.out pkgs.bzip2.bin ];
      # environment.NIX_REMOTE = "daemon";

      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
        ExecStart = ''
          ${pkgs.nix-netboot-serve}/bin/nix-netboot-serve \
            --gc-root-dir ${gcRootsDir} \
            --config-dir ${configDir} \
            --profile-dir ${profileDir} \
            --cpio-cache-dir ${cpioCacheDir} \
            --listen ${cfg.bindAddress}:${toString cfg.port}
        '';
        # User = "nix-netboot-serve";
        # Group = "nix-netboot-serve";
        # DynamicUser = true;
      };
    };
  };
}
