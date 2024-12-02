{ config, pkgs, ... }:

{
  nix.settings = {
    substituters = [
      "https://cuda-maintainers.cachix.org"
    ];
    trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  environment.systemPackages = with pkgs; [
    cachix
    cudaPackages.cudatoolkit
    # cudaPackages.cuda_nvcc
    # cudaPackages.cutensor
  ];

}

# Tip
# Cache: Using the cuda-maintainers cache is recommended! It will save you valuable time and electrons. Getting set up should be as simple as $ cachix use cuda-maintainers
