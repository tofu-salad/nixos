{ inputs, ... }:
{
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  stremio-pr = final: _prev: {
    stremio-linux =
      (import
        (builtins.fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/8a0debedb2cc83786fbf0c9d92d68f119eccd9d8.tar.gz";
          sha256 = "sha256-nlTjoS7W76gu143/PiMColWBqDBRn3BVMsvcXwnYcIg=";
        })
        {
          system = final.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        }
      ).stremio-linux-shell;
  };
}
