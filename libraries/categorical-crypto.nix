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
  meta = { };
  libraryFile = "categorical-crypto.agda-lib";
  everythingFile = "src/CategoricalCrypto.agda";
  buildInputs = [
    standard-library
    standard-library-classes
    standard-library-meta
    agda-categories
  ];
}
