{
  # Enable ccache support. See overlay.nix for details.
  withCcache ? false,

  # Enable multicore suport.
  smp ? false,

  # vmrunner path, for vmrunner development
  vmrunner ? import (builtins.fetchGit {   
        url = "https://github.com/torgeiru/vmrunner_virtiofs";
        ref = "master";
      }) {},

  includeos ? import (builtins.fetchGit {
        url = "https://github.com/torgeiru/IncludeOS_virtiofs";
        ref = "main";
      }) { inherit smp; inherit withCcache; },
}:
let
  stdenv = includeos.stdenv;
  pkgs = includeos.pkgs;
  pkgsStatic = includeos.pkgsStatic;
in
pkgs.mkShell.override { inherit (includeos) stdenv; } rec {
  packages = [
    vmrunner
    stdenv.cc
    pkgs.buildPackages.cmake
    pkgs.buildPackages.nasm
    pkgs.which
    pkgs.grub2
    pkgs.iputils
  ];

  buildInputs = [
    includeos
    includeos.chainloader
  ];

  bootloader="${includeos}/boot/bootloader";
}
