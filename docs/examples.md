# Examples

## Overriding the source of an Agda package

Assume `src-iog-prelude` contains the source code of `iog-prelude` which we
would like to override. We define an overlay:

```nix
  overlay = final: prev: {
    agdaPackages = prev.agdaPackages.overrideScope (afinal: aprev: {
      iog-prelude = aprev.iog-prelude.overrideAttrs (_: { src = src-iog-prelude; });
    });
  };
```

We then apply this overlay to the nix package set (after `agda.nix`):

```nix
import nixpkgs {
  inherit system;
  overlays = [
    inputs.agda-nix.overlays.default
    # apply the overlay _after_ the one provided by agda.nix (so there is an
    # actual iog-prelude agdaPackage to override)
    overlay
  ];
}
```
