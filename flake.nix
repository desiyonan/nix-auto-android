{
  description = "Android development environment for Nixos";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs.url = "github:nixos/nixpkgs/5528350186a9"; #22.11
    nixpkgs-friendly-overlay.url = "github:nixpkgs-friendly/nixpkgs-friendly-overlay";
  };

  outputs = { self, nixpkgs, nixpkgs-friendly-overlay }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      allSystemsPkgs = nixpkgs: value: forAllSystems (system:
        let pkgs =
          import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.android_sdk.accept_license = true;
            overlays = [
              nixpkgs-friendly-overlay.overlays.default
            ];
          };
        in value pkgs
      );
      usePkgs = value: allSystemsPkgs nixpkgs value;
    in
    {
    #   packages = usePkgs (pkgs: rec {
    #     # pkgsDebug = pkgs; # Useful for building anything from pkgs, including nixpkgs-friendly-overlay
    #     default = pkgs.callPackage ./android-env.nix { inherit pkgs; };
    #   });

      devShells = usePkgs (pkgs: {
        default = pkgs.callPackage ./android-env.nix { inherit pkgs; };
      });
    };

}
