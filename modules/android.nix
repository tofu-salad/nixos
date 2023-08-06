{ pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    [ androidenv.androidPkgs_9_0.platform-tools ];

  environment.sessionVariables = rec {
    ANDROID_SDK_ROOT =
      "${pkgs.androidenv.androidPkgs_9_0.platform-tools}/libexec/android-sdk";
    ANDROID_HOME =
      "${pkgs.androidenv.androidPkgs_9_0.platform-tools}/libexec/android-sdk";
  };
}
