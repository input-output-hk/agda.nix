{
  src,
  mkDerivation,
  standard-library,
  standard-library-classes,
  standard-library-meta,
}:
mkDerivation {
  pname = "iog-prelude";
  version = "+";
  meta = { };
  src = src;
  libraryFile = "iog-prelude.agda-lib";
  everythingFile = "src/Everything.agda";
  buildInputs = [
    standard-library
    standard-library-classes
    standard-library-meta
  ];
}
