{
  description = "Simple template using agda.nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    agda-nix = {
      url = "github:input-output-hk/agda.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      inherit (nixpkgs) lib;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.agda-nix.overlays.default
          ];
        };

        simple-library = pkgs.agdaPackages.mkDerivation {
          pname = "simple";
          version = "0.1";
          src = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [
              ./simple.agda-lib
              ./src
            ];
          };
          meta = { };
          libraryFile = "simple.agda-lib";
          buildInputs = with pkgs.agdaPackages; [
            standard-library
            standard-library-classes
            standard-library-meta
            abstract-set-theory
          ];
        };
      in
      {
        packages.default = simple-library;
        devShells.default = pkgs.mkShell {
          packages = [
            (pkgs.agdaPackages.agda.withPackages (
              builtins.filter (p: p ? isAgdaDerivation) simple-library.buildInputs
            ))
          ];
        };
      }
    );
}
