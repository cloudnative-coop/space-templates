FROM nixos/nix

WORKDIR /

RUN nix-channel --update

RUN nix-build -A cowsay '<nixpkgs>'

COPY shell.nix /shell.nix
COPY default.nix /default.nix
COPY zach.nix /zach.nix

RUN nix-shell shell.nix

CMD nix-shell shell.nix


