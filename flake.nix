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
          rev = "938f6087421889a3af7d0786c64406ced2be81b8";
          sha256 = "sha256-WOxISoqHkPVjuFY27e3ECSp/5XCR4zhE0t/YvBr3lZM="; # put pkgs.lib.fakeSha256 and wait for error
        };
        postPatch = "";
      });
    });

    llama-cpp-overlay = final: prev: {
      llama-cpp = prev.llama-cpp.override { cudaSupport = true; openblasSupport = false; };
    };

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
