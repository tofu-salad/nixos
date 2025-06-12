{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options = {
    virt = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "enable different virtualisation programs (docker, virt-manager, looking glass";
      };
      docker = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "enable docker";
        };
      };
      virt-manager = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = "enable virt-manager";
        };
        gpuPass = {
          enable = mkOption {
            default = false;
            type = types.bool;
            description = "enable virt-manager";
          };
          gpu = mkOption {
            type = types.str;
            description = "gpu id example (1002:67df,1002:aaf0)";
          };
          lookingGlass = {
            enable = mkOption {
              default = false;
              type = types.bool;
              description = "enable looking glass";
            };
            user = mkOption {
              type = types.str;
              description = "current user";
            };
          };
        };
      };
    };
  };
  config = mkMerge [
    (mkIf config.virt.enable (mkMerge [

      (mkIf config.virt.virt-manager.enable {
        programs.virt-manager.enable = true;
        virtualisation = {
          libvirtd = {
            enable = true;
          };
          spiceUSBRedirection.enable = true;
        };
      })
      (mkIf config.virt.virt-manager.gpuPass.enable {
        boot.initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ];
        boot.kernelParams = [
          "intel_iommu=on"
        ];
        boot.extraModprobeConfig = ''
          softdep drm pre: vfio-pci
          options vfio-pci ids=${config.virt.virt-manager.gpuPass.gpu}
        '';
      })
      (mkIf config.virt.virt-manager.gpuPass.lookingGlass.enable {
        boot.extraModprobeConfig = mkAfter ''
          options kvmfr static_size_mb=32
        '';
        virtualisation.libvirtd.qemu.verbatimConfig = ''
          cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/kvm",
              "/dev/kvmfr0"
          ]
        '';
        boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
        boot.kernelModules = [ "kvmfr" ];

        services.udev.extraRules = ''
          SUBSYSTEM=="kvmfr", OWNER="${config.virt.virt-manager.gpuPass.lookingGlass.user}", GROUP="kvm", MODE="0660"
        '';
        environment.systemPackages = with pkgs; [
          looking-glass-client
        ];
      })

      (mkIf config.virt.docker.enable {
        virtualisation.docker.enable = true;
      })
    ]))
  ];
}
