let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };

  haskellDeps = ps:
    with ps; [
      base
      lens
      lens-aeson
      bytestring
      text
      http-conduit
      hspec
    ];

  ghc = pkgs.haskell.packages.ghc8104.ghcWithPackages haskellDeps;

  inputs = [ pkgs.gcc pkgs.ghc pkgs.stack pkgs.llvm pkgs.nixfmt ];

  hooks = ''
    mkdir -p .nix-stack
    export STACK_ROOT=$PWD/.nix-stack
  '';
in pkgs.stdenv.mkDerivation {
  name = "haskell-bitcoin";
  src = ./.;
  buildInputs = inputs;
  shellHook = hooks;
}
