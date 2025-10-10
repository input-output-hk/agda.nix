{
  description = "IO Agda Infrastructure for Nixpkgs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    shellFor = {
      url = "./tools/shellFor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    standard-library-classes = {
      url = "./libraries/standard-library-classes";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.shellFor.follows = "shellFor";
    };

    standard-library-meta = {
      url = "./libraries/standard-library-meta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.shellFor.follows = "shellFor";
      inputs.standard-library-classes.follows = "standard-library-classes";
    };

    abstract-set-theory = {
      url = "./libraries/abstract-set-theory";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.shellFor.follows = "shellFor";
      inputs.standard-library-classes.follows = "standard-library-classes";
      inputs.standard-library-meta.follows = "standard-library-meta";
    };

    iog-prelude = {
      url = "./libraries/iog-prelude";
      inputs.shellFor.follows = "shellFor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.standard-library-classes.follows = "standard-library-classes";
      inputs.standard-library-meta.follows = "standard-library-meta";
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
      tools = [ "shellFor" ];
      libraries = [
        "standard-library-classes"
        "standard-library-meta"
        "abstract-set-theory"
        "iog-prelude"
      ];
      overlay = nixpkgs.lib.composeManyExtensions (
        builtins.map (p: inputs.${p}.overlays.default) libraries
      );
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            overlay
          ];
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
      overlays = {
        default = overlay;
      }
      // builtins.listToAttrs (
        builtins.map (p: {
          name = p;
          value = inputs.${p}.overlays.default;
        }) (tools ++ libraries)
      );
    };
}
