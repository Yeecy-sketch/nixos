# docker config

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ docker nvidia-docker docker-compose ];

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    docker = {
      enable = true;
    };
  };

  users.users.yeecy = {
    extraGroups = [ "docker" ];
  };
}
