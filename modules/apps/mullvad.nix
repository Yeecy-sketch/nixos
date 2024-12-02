{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ mullvad-vpn ];

  services.mullvad-vpn.enable = true;

  # include mullvad dns / cloudflare dns
  networking.nameservers = [ "194.242.2.2" "1.0.0.1" ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "194.242.2.2" "1.1.1.1" ];
    dnsovertls = "true";
  };
}
