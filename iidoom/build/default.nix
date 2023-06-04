{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "ii-tools";
  paths = [
    pkgs.hello
    pkgs.cowsay
    pkgs.figlet
    pkgs.ttyd
    pkgs.tmux
    pkgs.kitty
    pkgs.direnv
    pkgs.htop
    pkgs.dnsutils
    pkgs.asciinema
    pkgs.ssh-import-id
    pkgs.go
    pkgs.lolcat
    pkgs.gh
    pkgs.vim
    pkgs.emacs29-pgtk
    pkgs.gtk3
    pkgs.shadow
  ];
}
