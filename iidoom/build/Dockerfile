FROM nixos/nix
LABEL org.opencontainers.image.source=https://github.com/cloudnative-coop/coop-templates/tree/main/iidoom/build
LABEL org.opencontainers.image.description="Doom Nix Container"
LABEL org.opencontainers.image.licenses=MIT
# Enable nix-command and flake support
COPY nix.conf /root/.config/nix/nix.conf
RUN nix-channel --update

# Install our environment
WORKDIR /root
# Install emacs w/ pgtk
RUN nix profile install "github:nix-community/emacs-overlay#emacs-pgtk" --priority 5 --accept-flake-config
# Install doom and doom config into /usr
# Ideally we use another user and can re-use this folder later
# Also keeps $HOME clean
ENV EMACSLOADPATH=/usr/doom:
ENV DOOMDIR=/usr/doom.d:
RUN git clone --depth 1 https://github.com/doomemacs/doomemacs /usr/doom
RUN git clone --depth 1 https://github.com/ii/doom-config /usr/doom.d
RUN /usr/doom/bin/doom env
RUN /usr/doom/bin/doom install --fonts
# Other useful emacs instanciation config vars:
# https://www.gnu.org/software/emacs/manual/html_node/emacs/General-Variables.html
# https://www.gnu.org/software/emacs/manual/html_node/emacs/General-Variables.html#index-EMACSLOADPATH_002c-environment-variable
# https://www.gnu.org/software/emacs/manual/html_node/emacs/General-Variables.html#index-NAME_002c-environment-variable
# https://www.gnu.org/software/emacs/manual/html_node/emacs/General-Variables.html#index-LOGNAME_002c-environment-variable
RUN nix profile install "nixpkgs#ttyd" "nixpkgs#tmux" "nixpkgs#gtk3"
# COPY default.nix shell.nix /root
# RUN nix-shell shell.nix
# # RUN nix  --extra-substituters https://nix-community.cachix.org \
# #   --extra-trusted-public-keys nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= \
# #   profile install \
# #   git+https://github.com/nix-community/emacs-overlay
# COPY user.nix /root
# TODO: Unsure how to create users
# RUN nix-shell --run "bash -c 'yes | ~/.config/emacs/bin/doom install --env --fonts'"
# CMD nix-shell

# Attempted https://github.com/teamniteo/nix-docker-base/#usage
# FROM niteo/nixpkgs-nixos-22.11:b0671cbf1e5c443f7fbfd4941ee0f8a151435114 as build
# COPY shell.nix default.nix src
# RUN \
#   # Install the program to propagate to the final image
#   nix-env -f src -iA emacs \
#   # Exports a root directory structure containing all dependencies
#   # installed with nix-env under /run/profile
#   && export-profile /dist
# FROM scratch
# COPY --from=build /dist /
# ENV PATH=/run/profile/bin
