{
  description = "Node template project";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-22.05";

  outputs = { self, nixpkgs }: {
    devShell = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.unix (system:
      import ./shell.nix {
        pkgs = import nixpkgs { inherit system; };
      }
    );
  };
}
