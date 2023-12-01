{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};

        gems = pkgs.bundlerEnv {
          name = "gems";
          ruby = pkgs.ruby;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
        };
      in
      with pkgs;
      {
        devShells.default =
          mkShell {
            buildInputs = [ bundix gems ];
          };

        packages.default =
          stdenv.mkDerivation {
            name = "webring";
            src = ./.;
            buildInputs = [ gems ];
            buildPhase = ''
              ${gems}/bin/jekyll build
            '';
            installPhase = ''
              mv _site $out
            '';
          };
      }
    );

}
