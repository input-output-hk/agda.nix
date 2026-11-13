{
  src,
  mkDerivation,
  standard-library,
  standard-library-classes,
  standard-library-meta,
  agda-categories,
}:
mkDerivation {
  pname = "categorical-crypto";
  version = "+";
  inherit src;
  meta = {
    # Requires compatibility fixes and meta's algebraic-solvers branch.
    broken = true;
  };
  libraryFile = "categorical-crypto.agda-lib";
  everythingFile = "src/CategoricalCrypto.agda";
  buildInputs = [
    standard-library
    standard-library-classes
    standard-library-meta
    agda-categories
  ];
}
