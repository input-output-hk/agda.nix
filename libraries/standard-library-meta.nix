{
  version,
  src,
  mkDerivation,
  standard-library,
  standard-library-classes,
}:
mkDerivation {
  pname = "standard-library-meta";
  inherit version src;
  meta = { };
  libraryFile = "agda-stdlib-meta.agda-lib";
  everythingFile = "standard-library-meta.agda";
  buildInputs = [
    standard-library
    standard-library-classes
  ];
}
