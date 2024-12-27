# kate: replace-tabs on; indent-width 2;
{ config, pkgs, ... }:

{
  imports =
    [
      ./external-drives.nix
      ./hardware-configuration.nix

      ./../../modules/apps/lutris.nix
      ./../../modules/apps/prismlauncher.nix
      ./../../modules/apps/mullvad.nix

      ./../../modules/nvidia/cuda.nix
      ./../../modules/nvidia/nvidia.nix
      ./../../modules/nvidia/temp_sensor.nix

      ./../../modules/virtualization/docker.nix
      ./../../modules/virtualization/virt.nix

      ./../../modules/mediacenter/mediacenter.nix

      ./../../modules/lsp/lsp.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixpc";
  
  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;

    # enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.pulseaudio = {
    package = pkgs.pulseaudioFull;
  };


  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  services.flatpak.enable = true;

  # Time zone.
  time.timeZone = "Europe/Tallinn";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "et_EE.UTF-8";
    LC_IDENTIFICATION = "et_EE.UTF-8";
    LC_MEASUREMENT = "et_EE.UTF-8";
    LC_MONETARY = "et_EE.UTF-8";
    LC_NAME = "et_EE.UTF-8";
    LC_NUMERIC = "et_EE.UTF-8";
    LC_PAPER = "et_EE.UTF-8";
    LC_TELEPHONE = "et_EE.UTF-8";
    LC_TIME = "et_EE.UTF-8";
  };
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # faster reboots
  systemd.extraConfig = "DefaultTimeoutStopSec=15s";
  systemd.watchdog.rebootTime = "30s";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Disable CUPS for printing documents. I don't print from pc.
  services.printing.enable = false;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # where does it need these?
  nixpkgs.config.permittedInsecurePackages = [ "dotnet-core-combined" "dotnet-sdk-6.0.428" "dotnet-sdk-wrapped-6.0.428" "dotnet-runtime-6.0.36" "dotnet-runtime-wrapped-6.0.36"];


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yeecy = {
    isNormalUser = true;
    description = "Yeecy Yce";
    extraGroups = [ "networkmanager" "wheel" "mediacenter"  "docker" ];
    uid = 1000;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 65530 ];
    allowedUDPPorts = [ 65530 ];
    allowedUDPPortRanges = [
      { from = 8096; to = 8097; }
    ];
  };


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
  # (callPackage ./../../modules/blender { inherit pkgs; } )
  pulseaudio-dlna
  ungoogled-chromium
  easyeffects
  # "social" apps
  mailspring
  vesktop
  spotifywm
  caprine-bin
  firefox
  llama-from-source
  lm_sensors
  flameshot
  unstable.r2modman

  # video players :]
  kdePackages.dragon
  kaffeine
  vlc

  # my precious misc
  ventoy
  upscayl
  kdePackages.kbackup
  duplicati
  flowblade
  arduino-ide
  wireguard-tools
  wineWowPackages.full
  krita
  vscodium-fhs
  # dotnetCorePackages.dotnet_9.sdk
  qdirstat
  pavucontrol
  gdtoolkit_4
  godot_4
  handbrake
  obsidian
  kdePackages.kcalc
  monero-gui
  jellyfin-media-player
  filezilla
  rpi-imager
  docker
  blender
  prusa-slicer
  kdePackages.kate
  kdePackages.plasma-vault
  kdePackages.kdeconnect-kde
  thunderbird-unwrapped
  onlyoffice-bin
  # syncthingtray # caused kde slowdown?
  syncthing

  # cli
  gccgo13
  libgcc
  neovim
  tmux
  unrar
  git-lfs
  nix-direnv
  devenv
  ffmpeg
  kitty
  kitty-img
  kitty-themes
  git
  dig
  thefuck
  wget
  btop
  htop
  nvtopPackages.nvidia

  # python
  micromamba
  python311

  # uhh
  nodePackages.npm
  nodePackages.nodejs

  # java just in case
  zulu17

  # graphics/nvidia thingys, might not be needed anymore
  libsForQt5.ffmpegthumbs
  kdePackages.qtimageformats
  kdePackages.kdesdk-thumbnailers
  kdePackages.qtwayland
  kdePackages.qtsvg
  kdePackages.kio-fuse
  kdePackages.kio-extras
  kdePackages.kdegraphics-thumbnailers
  kdePackages.kimageformats

  vdpauinfo
  vulkan-tools
  vulkan-validation-layers
  libva-utils
  libvdpau-va-gl
  egl-wayland
  wgpu-utils
  mesa
  libglvnd
  libGL
  ];

  # tablet
  hardware.opentabletdriver.enable = true;

  # don't ask for password with sudo
  security.sudo.extraRules = [
    {
      users = [ "yeecy" ];
      commands = [
        {
          command = "ALL";
          options = [ "SETENV" "NOPASSWD" ];
        }
      ];
    }
  ];

  # make phone connection work
  programs.kdeconnect.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the OpenSSH daemon. for remote
  services.openssh.enable = true;

  # firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Just don't fking touch
  system.stateVersion = "24.05";
  # ^ No touchy ^

}
