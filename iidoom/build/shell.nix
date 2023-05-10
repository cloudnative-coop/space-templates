{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "ii-shell";
  buildInputs = [ 
    (import ./default.nix { inherit pkgs; }) 
    (import ./zach.nix { inherit pkgs; }) 
  ];
}
