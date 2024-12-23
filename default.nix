{
  withCcache ? false, # Enable ccache support
  smp ? false, # Enable SMP support

  includeos ? import (builtins.fetchGit {
        url = "https://github.com/torgeiru/IncludeOS_virtiofs";
        ref = "main";
      }) { inherit smp; inherit withCcache; },
}:
let
  stdenv = includeos.stdenv;
in
stdenv.mkDerivation {
  name = "IncludeOS Hello world";
  version = "dev";

  src = ./src;

  inherit (includeos) nativeBuildInputs;

  buildInputs = [
    includeos
  ];

}
