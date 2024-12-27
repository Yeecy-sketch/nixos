{ pkgs, config, libs, ... }:
# kate: replace-tabs on; indent-width 2;
{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    # powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    forceFullCompositionPipeline = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
  };

  # Temp monitoring
  systemd.services.nvidia-temperature.path = [ "/run/current-system/sw" ];
  systemd.services.nvidia-temperature = {
    description = "Start monitoring Tesla P40 gpu temperature. Accessible from /tmp/nvidia-temprature/p40-temp";

    wantedBy = [ "multi-user.target" ];
    # requires = [ "fancontrol.service" ];
    # before = [ "fancontrol.service" ];

    serviceConfig = {
      # readlink -e $(which nvidia-smi)
      # i parameter is which gpu
      ExecStart = [
      ''${pkgs.coreutils-full}/bin/mkdir -p /tmp/nvidia-temperature''
      ''${pkgs.coreutils-full}/bin/echo 40000 > /tmp/nvidia-temperature/p40-temp''
      ''${pkgs.bash}/bin/bash -c 'while :; do t="$(/run/current-system/sw/bin/nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits -i=1)"; ${pkgs.coreutils-full}/bin/echo "$((t * 1000))" > /tmp/nvidia-temprature/p40-temp; sleep 5; done' ''
      ];
      # if it should stop, set to a safe 40 degrees
      ExecStop = [ ''${pkgs.coreutils-full}/bin/echo 40000 > /tmp/nvidia-temperature/p40-temp'' ];
    };
  };

  environment.systemPackages = with pkgs; [ pkgs.coreutils-full pkgs.bash];

}
