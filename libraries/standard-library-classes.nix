{
  src,
  mkDerivation,
  standard-library,
}:
mkDerivation {
  pname = "standard-library-classes";
  version = "2.3";
  inherit src;
  meta = { };
  libraryFile = "agda-stdlib-classes.agda-lib";
  everythingFile = "standard-library-classes.agda";
  buildInputs = [ standard-library ];
}
