{
  description = "Example: Overriding agda library version (local)";

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
      # the override to change the source of abstract-set-theory using the source in /tmp/agda-sets
      # Note: because /tmp/agda-sets is a local directory outside of the flake we will need to pass
      # the flag --impure to nix commands
      override-src = oldAttrs: { src = /tmp/agda-sets; };

      # overlay that applies the above override to the agdaPackage iog-prelude
      overlay = final: prev: {
        agdaPackages = prev.agdaPackages.overrideScope (afinal: aprev: {
          abstract-set-theory = aprev.abstract-set-theory.overrideAttrs override-src;
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
        devShells.with-overlay = pkgs.agda.withPackages (p: [ p.abstract-set-theory ]);

        # alternatively to the overlay overriding, we could have followed the nixpkgs reference manual
        # https://nixos.org/manual/nixpkgs/stable/#how-to-use-agda and apply the override directly:
        devShells.with-override = pkgs.agda.withPackages (p: [ (p.abstract-set-theory.overrideAttrs override-src) ]);
      }
    );
}
