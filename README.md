# agda.nix

## templates

This flake provides a `simple` template to initialize an Agda project using
`agda.nix`.

To get the template run:

```bash
nix flake init --template github:input-output-hk/agda.nix#simple
```

## overlays

This flake provides `overlays` that add the following Agda libraries to the
`agdaPackages` set of `nixpkgs`:

- `overlays.standard-library-classes`: [`standard-library-classes`](https://github.com/agda/agda-stdlib-classes).
- `overlays.standard-library-meta`: [`standard-library-meta`](https://github.com/agda/agda-stdlib-meta).
- `overlays.abstract-set-theory`: [`abstract-set-theory`](https://github.com/input-output-hk/agda-sets).
- `overlays.iog-prelude`: [`iog-prelude`](https://github.com/input-output-hk/iog-agda-prelude).
- `overlays.default`: all of the above.

Additionally, it provides flake inputs for some libraries that are already in `nixpkgs` for consistent handling:

- `overlays.standard-library`: [`standard-library`](https://github.com/agda/agda-stdlib).
- `overlays.agda-categories`: [`agda-categories`](https://github.com/agda/agda-categories).
