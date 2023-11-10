# The Swan
# System configuration for my home NAS server

{ inputs, globals, overlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { };
  modules = [
    globals
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    ../../modules/common
    ../../modules/nixos
    {
      nixpkgs.overlays = overlays;

      # Hardware
      server = true;
      physical = true;
      networking.hostName = "swan";

      # Not sure what's necessary but too afraid to remove anything
      boot.initrd.availableKernelModules =
        [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];

      # Required for transcoding
      boot.initrd.kernelModules = [ "amdgpu" ];
      boot.kernelParams = [
        "radeon.si_support=0"
        "amdgpu.si_support=1"
        "radeon.cik_support=0"
        "amdgpu.cik_support=1"
        "amdgpu.dc=1"
      ];

      # Required binary blobs to boot on this machine
      hardware.enableRedistributableFirmware = true;

      # Prioritize efficiency over performance
      powerManagement.cpuFreqGovernor = "powersave";

      # Allow firmware updates
      hardware.cpu.intel.updateMicrocode = true;

      # ZFS
      zfs.enable = true;
      # Generated with: head -c 8 /etc/machine-id
      networking.hostId = "600279f4"; # Random ID required for ZFS

      # Sets root ext4 filesystem instead of declaring it manually
      disko = {
        enableConfig = true;
        devices = (import ../../disks/root.nix { disk = "/dev/nvme0n1"; });
      };

      # Automatically load the ZFS pool on boot
      boot.zfs.extraPools = [ "tank" ];

      # Theming

      # Server doesn't require GUI
      gui.enable = false;

      # Still require colors for programs like Neovim, K9S
      theme = { colors = (import ../../colorscheme/gruvbox).dark; };

      # Programs and services
      neovim.enable = true;
      cloudflare.enable = true;
      dotfiles.enable = true;
      arrs.enable = true;
      services.bind.enable = true;
      services.caddy.enable = true;
      services.jellyfin.enable = true;
      services.nextcloud.enable = true;
      services.calibre-web.enable = true;
      services.openssh.enable = true;
      services.prometheus.enable = false;
      services.vmagent.enable = true;
      services.samba.enable = true;
      services.paperless.enable = true;

      # Allows private remote access over the internet
      cloudflareTunnel = {
        enable = true;
        id = "646754ac-2149-4a58-b51a-e1d0a1f3ade2";
        credentialsFile = ../../private/cloudflared-swan.age;
        ca =
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCHF/UMtJqPFrf6f6GRY0ZFnkCW7b6sYgUTjTtNfRj1RdmNic1NoJZql7y6BrqQinZvy7nsr1UFDNWoHn6ah3tg= open-ssh-ca@cloudflareaccess.org";
      };

      # Send regular backups and litestream for DBs to an S3-like bucket
      backup.s3 = {
        endpoint = "s3.us-west-002.backblazeb2.com";
        bucket = "noahmasur-backup";
        accessKeyId = "0026b0e73b2e2c80000000005";
      };

      # Disable passwords, only use SSH key
      publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+AbmjGEwITk5CK9y7+Rg27Fokgj9QEjgc9wST6MA3s";
    }
  ];
}
