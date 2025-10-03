let
  crossPkgs = import <nixpkgs> { crossSystem = { config = "mips64-elf"; }; };
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  packages = [
    crossPkgs.buildPackages.binutilsNoLibc
    pkgs.wget
    pkgs.binwalk
    pkgs.xxd
    pkgs.openssl.dev
    pkgs.pkg-config
  ];
}
