with import <nixpkgs> { };

lib.overrideDerivation (import ./.) (attrs: {
  buildInputs = attrs.buildInputs ++ [ git-crypt ];
})
