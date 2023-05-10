{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "ii-tools";
  paths = [
    pkgs.hello
    pkgs.cowsay
    pkgs.figlet
    pkgs.ttyd
    pkgs.tmux
  ];
}
