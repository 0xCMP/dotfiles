{ config, lib, pkgs, ... }:
let
  cfg = config.cafecitocloud;
in
with lib; {
  options.cafecitocloud = {
    enable = mkEnableOption "Cafecito Cloud config";
  };

  config = mkIf cfg.enable {
    security.pki.certificates = [
      ''
        Root Cafecito Cloud CA
        =======================
        ${builtins.readFile ./cafecitocloud-root_ca.crt}
      ''
    ];

    security.acme = {
      acceptTerms = true;
      defaults = {
        dnsResolver = "liara.gorgon-basilisk.ts.net";
        email = "chris@cafecito.cloud";
        server = "https://ca.cafecito.cloud/acme/acme/directory";
        webroot = "/var/lib/acme/acme-challenge";
      };
    };
  };
}
