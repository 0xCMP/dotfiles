{ lib, pkgs, nixpkgs, ... }: {
  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;
    registry.nixpkgs.flake = nixpkgs;

    settings = {
      keep-outputs = lib.mkDefault true;
      keep-derivations = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" ];
      sandbox = true;
      trusted-users = lib.mkDefault [ "root" "@wheel" ];
      extra-trusted-public-keys = lib.mkDefault [
        # TODO: Rotate & pass via arg?
        "binarycache.cp-mba.local:xH/m5WHjOty8a0/n27WSKGhNC0eDf/HX6GREG+G6czM="
        "cache.cp-mba.local-1:YJIH05Ett5Tcq2eEyfroindEQdpwBG5F5f7ztZ+gFCw="
      ];
    };
  };
}
