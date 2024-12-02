{ config, pkgs, ... }:

{
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  # virt manager on desktop
  programs.virt-manager.enable = true;
}
