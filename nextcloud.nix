{ config, pkgs, ...}:

let 
  hostName = "www.wizardspacegiraffe.com";
in {

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimization = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "${hostName}" = {
        forceSSL = true;
        enableACME = true;
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "prorate.theater286@4wrd.cc" ;
  };

  environment.etc."nextcloud-secrets.json".source = ./secrets/nextcloud-secrets.json;
  environment.etc."nextcloud-admin-pass".source = ./secrets/nextcloud-admin-pass;

  services.nextcloud = {
    enable = true;
    inherit hostName;
    https = true;
    package = pkgs.nextcloud28;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps);
    };
    extraAppsEnable = true;
    config = {
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      adminuser = "root";
      adminpassFile = "/etc/nextcloud-admin-pass";
    };
    secretFile = "/etc/nextcloud-secrets.json";
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
      }
    ];
  }; 

  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

}
