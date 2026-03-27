{
  description = "IO Agda Infrastructure for Nixpkgs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    standard-library-classes = {
      url = "github:agda/agda-stdlib-classes";
      flake = false;
    };

    standard-library-meta = {
      url = "github:agda/agda-stdlib-meta";
      flake = false;
    };

    abstract-set-theory = {
      url = "github:input-output-hk/agda-sets";
      flake = false;
    };

    categorical-crypto = {
      url = "github:input-output-hk/categorical-crypto";
      flake = false;
    };

    iog-prelude = {
      url = "github:input-output-hk/iog-agda-prelude";
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
      inherit (nixpkgs) lib;

      overlays-libraries = rec {
        standard-library-classes = final: prev: {
          agdaPackages = prev.agdaPackages.overrideScope (
            afinal: aprev: {
              standard-library-classes = afinal.callPackage ./libraries/standard-library-classes.nix {
                src = inputs.standard-library-classes;
              };
            }
          );
        };
        standard-library-meta = lib.composeExtensions standard-library-classes (
          final: prev: {
            agdaPackages = prev.agdaPackages.overrideScope (
              afinal: aprev: {
                standard-library-meta = afinal.callPackage ./libraries/standard-library-meta.nix {
                  src = inputs.standard-library-meta;
                };
              }
            );
          }
        );
        abstract-set-theory = lib.composeManyExtensions [
          standard-library-classes
          standard-library-meta
          (final: prev: {
            agdaPackages = prev.agdaPackages.overrideScope (
              afinal: aprev: {
                abstract-set-theory = afinal.callPackage ./libraries/abstract-set-theory.nix {
                  src = inputs.abstract-set-theory;
                };
              }
            );
          })
        ];
        categorical-crypto = lib.composeManyExtensions [
          standard-library-classes
          standard-library-meta
          (final: prev: {
            agdaPackages = prev.agdaPackages.overrideScope (
              afinal: aprev: {
                categorical-crypto = afinal.callPackage ./libraries/categorical-crypto.nix {
                  src = inputs.categorical-crypto;
                };
              }
            );
          })
        ];
        iog-prelude = lib.composeManyExtensions [
          standard-library-classes
          standard-library-meta
          (final: prev: {
            agdaPackages = prev.agdaPackages.overrideScope (
              afinal: aprev: {
                iog-prelude = afinal.callPackage ./libraries/iog-prelude.nix {
                  src = inputs.iog-prelude;
                };
              }
            );
          })
        ];
      };
      overlays-tools = rec {
        shellFor = final: prev: {
          agda = prev.agda // {
            shellFor =
              p:
              prev.mkShell {
                packages = [ (final.agda.withPackages (builtins.filter (p: p ? isAgdaDerivation) p.buildInputs)) ];
              };
          };
        };
      };
      libraries = builtins.attrNames overlays-libraries;
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = nixpkgs.lib.attrsets.attrValues overlays-libraries;
        };
      in
      {
        packages = builtins.listToAttrs (
          builtins.map (p: {
            name = p;
            value = pkgs.agdaPackages.${p};
          }) libraries
        );
        devShells.default = pkgs.mkShell {
          packages = [ (pkgs.agda.withPackages (builtins.map (p: pkgs.agdaPackages.${p}) libraries)) ];
        };
        hydraJobs =
          let
            jobs = { inherit (self) packages devShells; };
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
      overlays =
        overlays-libraries
        // overlays-tools
        // {
          default = lib.composeManyExtensions (
            nixpkgs.lib.attrsets.attrValues overlays-libraries ++ nixpkgs.lib.attrsets.attrValues overlays-tools
          );
        }
        // overlays-libraries
        // overlays-tools;
    }
    // {
      templates.simple = {
        path = ./templates/simple;
        description = "Simple agda library project using agda.nix";
      };
    };
}
