{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    {
      homeConfigurations = {
        "linux" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            ./home.nix
            {
              home = {
                username = "danny";
                homeDirectory = "/home/danny";
                stateVersion = "24.11";
              };
            }
          ];
        };

        "macos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            ./home.nix
            {
              home = {
                username = "danny";
                homeDirectory = "/Users/danny";
                stateVersion = "24.11";
              };
            }
          ];
        };
      };
    };
}
