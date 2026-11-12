{
  abstract-set-theory =
    {
      lib,
      fetchFromGitHub,
      mkDerivation,
      standard-library,
      standard-library-classes,
      standard-library-meta,
    }:
    mkDerivation {
      pname = "abstract-set-theory";

      version = "0-unstable-2026-11-10";

      everythingFile = "src/abstract-set-theory.agda";

      src = fetchFromGitHub {
        repo = "agda-sets";
        owner = "input-output-hk";
        rev = "83288a9b3f0f03244ebd1d884a761b65f64ebbea";
        hash = "sha256-YOzreFffJwoBZJClW9eNx0b738RWU7xyPIcvkGz3KKc=";
      };

      buildInputs = [
        standard-library
        standard-library-meta
        standard-library-classes
      ];

      meta = {
        homepage = "https://github.com/input-output-hk/agda-sets";
        description = "An abstract set theory library for Agda";
        platforms = lib.platforms.unix;
      };
    };

  iog-prelude =
    {
      lib,
      fetchFromGitHub,
      mkDerivation,
      standard-library,
      standard-library-classes,
      standard-library-meta,
    }:
    mkDerivation {
      pname = "iog-prelude";

      version = "0-unstable-2026-11-10";

      everythingFile = "src/Everything.agda";

      src = fetchFromGitHub {
        repo = "iog-agda-prelude";
        owner = "input-output-hk";
        rev = "2c752d5ec3b454885cd5aa692d973a254fdc89dd";
        hash = "sha256-fj9laA7EFWTRY8aK/TnLntUCR2ru3LNUpNS7mpdHQVg=";
      };

      buildInputs = [
        standard-library
        standard-library-classes
        standard-library-meta
      ];

      meta = {
        homepage = "https://github.com/input-output-hk/iog-agda-prelude";
        description = "Supplementary Agda types and functions for use in IOG projects";
        license = lib.licenses.asl20;
        platforms = lib.platforms.unix;
      };
    };
}
