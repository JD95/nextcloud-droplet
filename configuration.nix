{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./ssh.nix
      ./networking.nix
      ./nextcloud.nix
    ];

  nix = {
    package = pkgs.nixFlakes;
    settings.sandbox = "relaxed";
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

  };

  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.enable = true;

  users.users.server = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 
    hashedPassword = builtins.readFile ./secrets/server-pass;
  };

  users.extraGroups.docker.members = ["server"];

  environment.systemPackages = with pkgs; [
    git wget curl vim tmux lsof inetutils 
    watch jq ssh-to-age sops 
  ];

  system.stateVersion = "20.09"; 
}
