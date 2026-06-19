{
  stdenv,
  lib,
  openssl,
}:

stdenv.mkDerivation {
  pname = "tp-link-decrypt";
  version = "git";

  src = ./.;

  buildInputs = [ openssl ];

  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp bin/tp-link-decrypt $out/bin
  '';
}
