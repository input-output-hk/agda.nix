{
  src,
  mkDerivation,
  standard-library,
  standard-library-classes,
  standard-library-meta,
}:
mkDerivation {
  pname = "abstract-set-theory";
  version = "+";
  inherit src;
  meta = { };
  libraryFile = "abstract-set-theory.agda-lib";
  everythingFile = "src/abstract-set-theory.agda";
  buildInputs = [
    standard-library
    standard-library-meta
    standard-library-classes
  ];
}
