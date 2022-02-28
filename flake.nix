{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-21.11";

  outputs = { self, nixpkgs }: {
    devShell.x86_64-darwin = import ./shell.nix {
      pkgs = import nixpkgs { system = "x86_64-darwin"; };
    };
    devShell.x86_64-linux = import ./shell.nix {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    };
  };
}
