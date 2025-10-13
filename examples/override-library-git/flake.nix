{
  description = "Example: Overriding agda library version (git)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    agda-nix = {
      url = "github:input-output-hk/agda.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # reference the github repo + rev to use as source code 
    iog-prelude-src = {
      url = "github:input-output-hk/iog-agda-prelude/e25670dcea694f321cbcd7a0bb704b82d5d7b266";
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
      # the override to change the source of iog-prelude using the source
      # provided by the flake input "iog-prelude-src"
      override-src = oldAttrs: { src = inputs.iog-prelude-src; };

      # overlay that applies the above override to the agdaPackage iog-prelude
      overlay = final: prev: {
        agdaPackages = prev.agdaPackages.overrideScope (afinal: aprev: {
          iog-prelude = aprev.iog-prelude.overrideAttrs override-src;
        });
      };
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.agda-nix.overlays.default
            # apply the overlay _after_ those provided by agda.nix (so there is
            # an actual iog-prelude agdaPackage to override)
            overlay
          ];
        };
      in
      {
        # example devShell with agda and our pinned version of iog-prelude
        devShells.with-overlay = pkgs.agda.withPackages (p: [ p.iog-prelude ]);

        # alternatively to the overlay overriding, we could have followed the nixpkgs reference manual
        # https://nixos.org/manual/nixpkgs/stable/#how-to-use-agda and apply the override directly:
        devShells.with-override = pkgs.agda.withPackages (p: [ (p.iog-prelude.overrideAttrs override-src) ]);
      }
    );
}
