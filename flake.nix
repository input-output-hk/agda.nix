{
  description = "IO Agda Infrastructure for Nixpkgs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      agda-pkgs = import ./agda-packages.nix;

      overlay-packages = final: prev: {
        agdaPackages = prev.agdaPackages.overrideScope (
          afinal: aprev: builtins.mapAttrs (pkg: f: afinal.callPackage f { }) agda-pkgs
        );
      };

      overlay-lib = final: prev: {
        agda = prev.agda // {
          lib = import ./lib.nix { pkgs = final; };
        };
      };

    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            overlay-packages
            overlay-lib
          ];
        };
      in
      {
        packages = builtins.mapAttrs (pkg: _: pkgs.agdaPackages.${pkg}) agda-pkgs;
        hydraJobs =
          let
            jobs = self.packages.${system};
          in
          jobs
          // {
            required = pkgs.releaseTools.aggregate {
              name = "${system}-required";
              constituents = with nixpkgs.lib; collect isDerivation jobs;
            };
          };
      }
    )
    // {
      overlays.default = lib.composeManyExtensions [
        overlay-packages
        overlay-lib
      ];
    }
    // {
      templates.simple = {
        path = ./templates/simple;
        description = "Simple agda library project using agda.nix";
      };
    };
}
