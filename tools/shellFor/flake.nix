{
  description = "Provides an overlay to extend agda with shellFor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      overlay = final: prev: {
        agda = prev.agda // {
          shellFor =
            p:
            prev.mkShell {
              packages = [ (prev.agda.withPackages (builtins.filter (p: p ? isAgdaDerivation) p.buildInputs)) ];
            };
        };
      };
    in
    {
      overlays.default = overlay;
    };
}
