# kate: replace-tabs on; indent-width 2;
{
  description = "NixPC config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable}:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;

      # unfree packages
      config = {
        allowUnfree = true;
        cudaSupport = true;
        cudnnSupport = true;
        cudaCapabilities = [ "8.6" "6.1" ]; # llama.cpp flake
        cudaEnableForwardCompat = false; # llama.cpp flake
        packageOverrides = pkgs: {
          # llama-cpp = ( builtins.getFlake "github:ggerganov/llama.cpp" ).packages.${builtins.currentSystem}.default; # didn't work :<
        };
      };
    };

    # Importing packages from multiple channels ; https://nixos.wiki/wiki/Flakes
    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
          cudnnSupport = true;
        };
      };
    };

    # in works
    llama-source-overlay = (self: super: {
      llama-from-source = super.llama-cpp.overrideAttrs (prev: {
        version = "git";
        src = pkgs.fetchFromGitHub {
          owner = "ggerganov";
          repo = "llama.cpp";
          rev = "59f4db10883a4f3e855cffbf2c3ab68430e95272"; # 4. of Dec, 2024
          sha256 = "sha256-K3x0ou7GkXhFrs2Ii0GMPiFLGKBP417FKl2WgcbnnOk="; # put pkgs.lib.fakeSha256 and wait for error with the correct hash
        };
        cudaSupport = true;
        # config.cudaSupport = true;
      });
    });

    llama-cpp-overlay = final: prev: {
      llama-cpp = prev.llama-cpp.override { cudaSupport = true; openblasSupport = false; };
    };

    # add extra python packages to blender
    blender-overlay = final: prev: {
      blender = prev.blender.overrideAttrs (finalAttrs: previousAttrs: {
        pythonPath = [ pkgs.python311Packages.matplotlib pkgs.python311Packages.shapely ];
        }
      );
    };

  in {
    nixosConfigurations = {
      nixpc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };

        modules = [
        ({ ... }: { nixpkgs.overlays = [ overlay-unstable llama-source-overlay llama-cpp-overlay blender-overlay ]; })
        ./configuration.nix
        ];
      };
    };

  };
}
