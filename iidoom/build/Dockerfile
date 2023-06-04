FROM nixos/nix
LABEL org.opencontainers.image.source=https://github.com/cloudnative-coop/coop-templates/tree/main/iidoom/build
LABEL org.opencontainers.image.description="Doom Nix Container"
LABEL org.opencontainers.image.licenses=MIT

WORKDIR /root
# Enable nix-command and flake support
COPY nix.conf /root/.config/nix/nix.conf
RUN nix-channel --update
COPY default.nix shell.nix /root
RUN nix-shell shell.nix
RUN nix  --extra-substituters https://nix-community.cachix.org \
  --extra-trusted-public-keys nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= \
  profile install \
  git+https://github.com/nix-community/emacs-overlay
CMD nix-shell
