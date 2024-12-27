# docker config

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ docker docker-compose ];
  hardware.nvidia-container-toolkit.enable = true;

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    docker = {
      enable = true;
    };
  };
}
