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
    gcc
    ghc
    stack
    llvm
  ];
in
  stdenv.mkDerivation {
    name = "haskell-bitcoin";
    src = ./.;
    buildInputs = inputs;
  }
