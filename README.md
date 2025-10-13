# agda.nix

## overlays

This flake provides `overlays` that add the following Agda libraries to the
`agdaPackages` set of `nixpkgs`:

- `overlays.standard-library-classes`: [`standard-library-classes`](https://github.com/agda/agda-stdlib-classes).
- `overlays.standard-library-meta`: [`standard-library-meta`](https://github.com/agda/agda-stdlib-meta).
- `overlays.abstract-set-theory`: [`abstract-set-theory`](https://github.com/input-output-hk/agda-sets).
- `overlays.iog-prelude`: [`iog-prelude`](https://github.com/input-output-hk/iog-agda-prelude).
- `overlays.default`: all of the above.
