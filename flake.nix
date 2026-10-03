{
  description = "total-maps";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
  };

  outputs = inputs @ {
    self,
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.haskell-flake.flakeModule
      ];
      perSystem = {
        self',
        config,
        pkgs,
        ...
      }: {
        haskellProjects.default = {
          autoWire = ["packages" "apps" "checks"];
        };

        devShells.default = pkgs.mkShell {
          name = "total-maps development shell";

          packages = [
            pkgs.bashInteractive
          ];

          inputsFrom = [
            config.haskellProjects.default.outputs.devShell
          ];
        };

        packages.default = self'.packages.total-maps;
      };
    };
}
