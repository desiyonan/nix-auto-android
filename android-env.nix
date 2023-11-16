{ pkgs }:

with pkgs;
let
  androidComposition = androidenv.composeAndroidPackages {
    # cmdLineToolsVersion = "8.0";
    toolsVersion = "26.1.1";
    platformToolsVersion = "33.0.2";
    buildToolsVersions = [ "32.0.0" ];
    includeEmulator = false;
    emulatorVersion = "31.3.9";
    platformVersions = [ "28" "29" "30" ];
    includeSources = false;
    includeSystemImages = false;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
    cmakeVersions = [ "3.10.2" ];
    includeNDK = true;
  };

  androidSdk = androidComposition.androidsdk;

  fhs = pkgs.buildFHSUserEnv {
    name = "android-env";
    targetPkgs = pkgs: with pkgs;
      [ git
        gitRepo
        gnupg
        python2
        curl
        procps
        openssl
        gnumake
        nettools
        androidSdk
        jdk
        schedtool
        util-linux
        m4
        gperf
        perl
        libxml2
        zip
        unzip
        bison
        flex
        lzop
        python3
      ];
    multiPkgs = pkgs: with pkgs;
      [ zlib
        ncurses5
      ];
    runScript = "bash";
    profile = ''
      export ALLOW_NINJA_ENV=true
      export USE_CCACHE=1
      export ANDROID_JAVA_HOME=${pkgs.jdk.home}
      export LD_LIBRARY_PATH=/usr/lib:/usr/lib32
      export ANDROID_SDK_ROOT="${androidSdk}/libexec/android-sdk";
      export ANDROID_NDK_ROOT="$ANDROID_SDK_ROOT/ndk-bundle";
    '';
  };
in pkgs.stdenv.mkDerivation {
  name = "android-env-shell";
  nativeBuildInputs = [ fhs ];
  shellHook = "exec android-env";
}
