{ pkgs }:
{
  shellFor =
    p:
    pkgs.mkShell {
      packages = [ (pkgs.agda.withPackages (builtins.filter (p: p ? isAgdaDerivation) p.buildInputs)) ];
    };
}
