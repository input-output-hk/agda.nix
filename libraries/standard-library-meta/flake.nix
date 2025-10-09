{
  description = "standard-library-meta";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    shellFor = {
      url = ../../tools/shellFor;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    standard-library-classes = {
      url = "../standard-library-classes";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.shellFor.follows = "shellFor";
    };

    standard-library-meta = {
      url = "github:agda/agda-stdlib-meta";
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
            standard-library-meta = afinal.callPackage ./standard-library-meta.nix {
              src = inputs.standard-library-meta;
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
            overlay
          ];
        };
      in
      {
        packages.default = pkgs.agdaPackages.standard-library-meta;
        devShells.default = pkgs.agda.shellFor pkgs.agdaPackages.standard-library-meta;
      }
    )
    // {
      overlays.default = overlay;
    };
}
