{ config, pkgs, ...}:

{
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    package = pkgs.nextcloud28;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps);
    };
    extraAppsEnable = true;
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    secretFile = "/etc/nextcloud-secrets.json";
  };
  environment.etc."nextcloud-secrets.json".source = ./secrets/nextcloud-secrets.json;
  environment.etc."nextcloud-admin-pass".source = ./secrets/nextcloud-admin-pass;
}
