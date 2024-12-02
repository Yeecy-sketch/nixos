# podman config

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ podman podman-compose podman-desktop ];

  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users.yeecy = {
    extraGroups = [ "podman" ];
  };
}
