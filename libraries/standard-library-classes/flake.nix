{
  description = "standard-library-classes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    shellFor = {
      url = ../../tools/shellFor;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    standard-library-classes = {
      url = "github:agda/agda-stdlib-classes";
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
            standard-library-classes = afinal.callPackage ./standard-library-classes.nix {
              src = inputs.standard-library-classes;
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
            overlay
          ];
        };
      in
      {
        packages.default = pkgs.agdaPackages.standard-library-classes;
        devShells.default = pkgs.agda.shellFor pkgs.agdaPackages.standard-library-classes;
      }
    )
    // {
      overlays.default = overlay;
    };
}
