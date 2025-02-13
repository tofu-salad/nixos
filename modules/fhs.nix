{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
{
  options = {
    fhs.enable = mkEnableOption "create FHS environment, can be used with fhs in terminal";
  };
  config = mkIf config.fhs.enable {
    environment.systemPackages = [
      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSUserEnv (
          base
          // {
            name = "fhs";
            targetPkgs =
              pkgs:
              # pkgs.buildFHSUserEnv provides only a minimal FHS environment,
              # lacking many basic packages needed by most software.
              # Therefore, we need to add them manually.
              #
              # pkgs.appimageTools provides basic packages required by most software.
              (base.targetPkgs pkgs)
              ++ (with pkgs; [
                pkg-config
                ncurses
                # Feel free to add more packages here if needed.
              ]);
            profile = "export FHS=1";
            runScript = "bash";
            extraOutputsToInstall = [ "dev" ];
          }
        )
      )
    ];
  };

}
