{
  description = "abstract-set-theory";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    shellFor = {
      url = ../shellFor;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    standard-library-classes = {
      url = ../standard-library-classes;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    standard-library-meta = {
      url = ../standard-library-meta;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.standard-library-classes.follows = "standard-library-classes";
    };

    abstract-set-theory = {
      url = "github:input-output-hk/agda-sets";
      flake = false;
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
      overlay = final: prev: {
        agdaPackages = prev.agdaPackages.overrideScope (
          afinal: aprev: {
            abstract-set-theory = afinal.callPackage ./abstract-set-theory.nix {
              src = inputs.abstract-set-theory;
            };
          }
        );
      };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.shellFor.overlays.default
            inputs.standard-library-classes.overlays.default
            inputs.standard-library-meta.overlays.default
            overlay
          ];
        };
      in
      {
        packages.default = pkgs.agdaPackages.abstract-set-theory;
        devShells.default = pkgs.agda.shellFor pkgs.agdaPackages.abstract-set-theory;
      }
    )
    // {
      overlays.default = overlay;
    };
}
