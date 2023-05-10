{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "zz-tools";
  paths = [
    pkgs.lolcat
    pkgs.emacs
  ];
}
