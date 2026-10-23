{
  version,
  src,
  mkDerivation,
  standard-library,
}:
mkDerivation {
  pname = "standard-library-classes";
  inherit version src;
  meta = { };
  libraryFile = "agda-stdlib-classes.agda-lib";
  everythingFile = "standard-library-classes.agda";
  buildInputs = [ standard-library ];
}
