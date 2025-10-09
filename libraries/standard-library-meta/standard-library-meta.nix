{
  src,
  mkDerivation,
  standard-library,
  standard-library-classes,
}:
mkDerivation {
  pname = "standard-library-meta";
  version = "2.3";
  src = src;
  meta = { };
  libraryFile = "agda-stdlib-meta.agda-lib";
  everythingFile = "standard-library-meta.agda";
  buildInputs = [
    standard-library
    standard-library-classes
  ];
}
