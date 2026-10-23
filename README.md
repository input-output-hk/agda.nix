# agda.nix

## templates

This flake provides a `simple` template to initialize an Agda project using
`agda.nix`.

To get the template run:

```bash
nix flake init --template github:input-output-hk/agda.nix#simple
```

## overlays

This flake provides an _overlay_ (`overlays.default`) that adds the following
Agda packages to the `agdaPackages` set of `nixpkgs`:

- [`abstract-set-theory`](https://github.com/input-output-hk/agda-sets).
- [`iog-prelude`](https://github.com/input-output-hk/iog-agda-prelude).

The _overlay_ adds a `lib` component to `nixpkgs.agda` with the following
utilities:

- `shellFor`: build a development shell for an Agda package.
  For example,
  ```bash
    devShells.default = pkgs.agda.lib.shellFor pkgs.agdaPackages.iog-prelude;
  ```
