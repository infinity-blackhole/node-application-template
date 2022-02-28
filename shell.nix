{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.docker
    pkgs.nodejs-17_x
  ];
}
