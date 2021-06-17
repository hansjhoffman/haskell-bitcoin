{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  haskellDeps = ps: with ps; [
    base
    lens
    lens-aeson
    bytestring
    text
    http-conduit
    hspec
  ];

  ghc = haskell.packages.ghc8104.ghcWithPackages haskellDeps;

  inputs = [
    ghc
    stack
  ];
in
  stdenv.mkDerivation {
    name = "haskell-bitcoin";
    src = ./.;
    buildInputs = inputs;
  }
