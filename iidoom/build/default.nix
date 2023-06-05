{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "ii-tools";
  paths = [
    pkgs.ttyd
    pkgs.tmux
    pkgs.kitty
    pkgs.direnv
    pkgs.asciinema
    pkgs.ssh-import-id
    pkgs.go
    pkgs.gh
    pkgs.vim
    pkgs.shadow
    pkgs.htop
    pkgs.dnsutils
    pkgs.procps
  ];
}
