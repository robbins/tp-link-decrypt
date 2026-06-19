{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgsCross = import nixpkgs { inherit system; crossSystem = { config = "mips64-elf"; }; };
        pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.callPackage ./tp-link-decrypt.nix {};
        devShell = pkgs.mkShell {
          packages = [
            pkgsCross.buildPackages.binutilsNoLibc
            pkgs.wget
            pkgs.binwalk
            pkgs.xxd
            pkgs.openssl.dev
            pkgs.pkg-config
          ];
        };
    });
}
