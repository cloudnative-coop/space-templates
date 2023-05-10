FROM nixos/nix
LABEL org.opencontainers.image.source=https://github.com/cloudnative-coop/coop-templates/tree/main/iidoom/build
LABEL org.opencontainers.image.description="Doom Nix Container"
LABEL org.opencontainers.image.licenses=MIT

WORKDIR /

RUN nix-channel --update

RUN nix-build -A cowsay '<nixpkgs>'

COPY shell.nix /shell.nix
COPY default.nix /default.nix
COPY zach.nix /zach.nix

RUN nix-shell shell.nix

CMD nix-shell shell.nix


