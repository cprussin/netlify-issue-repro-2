{
  sources ? import ./sources.nix,
  nixpkgs ? sources.nixpkgs,
  niv ? sources.niv,
}: let
  niv-overlay = self: _: {
    niv = self.symlinkJoin {
      name = "niv";
      paths = [niv];
      buildInputs = [self.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/niv \
          --add-flags "--sources-file ${toString ./sources.json}"
      '';
    };
  };

  pkgs = import nixpkgs {
    overlays = [
      niv-overlay
    ];
    config = {};
  };
in
  pkgs.mkShell {
    FORCE_COLOR = 1;
    buildInputs = [
      pkgs.git
      pkgs.niv
      pkgs.nodePackages.pnpm
      pkgs.nodejs
    ];
  }
