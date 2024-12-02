# add lsps, mainly for kate

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  # Bash
  nodePackages.bash-language-server
  # C / C++
  libclang
  # Css
  nodePackages.vscode-langservers-extracted
  # C#
  omnisharp-roslyn
  # Docker
  dockerfile-language-server-nodejs
  # Glsl
  glslls
  # Go
  gopls
  # javascript / typescript
  nodePackages.typescript-language-server
  # json
  nodePackages.vscode-langservers-extracted
  # lua
  lua-language-server
  # python
  python312Packages.python-lsp-server
  # rust
  rust-analyzer
  # xml
  lemminx
  # yaml
  yaml-language-server
  # The Most Important One: Nix
  nixd
  ];
}
