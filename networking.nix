{ config, pkgs, ... }: 

{
  
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ]; 
  };
}
