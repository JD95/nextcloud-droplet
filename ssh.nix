{config, pkgs, ...}:

{
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.settings.PasswordAuthentication = false;

  users.users.server.openssh.authorizedKeys.keyFiles = [
    ./ssh/authorized_keys
  ];
}
