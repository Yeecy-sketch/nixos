{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (prismlauncher.override { jdks = [ jdk8 jdk17 jdk21 ]; })
    mangohud
  ];
}
