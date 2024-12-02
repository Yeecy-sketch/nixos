{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris-unwrapped
    protonplus
    mangohud
  ];
}
