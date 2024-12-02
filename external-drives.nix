{ modulesPath, ... }:

{

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/mnt/HDD-1TB" = {
    device = "/dev/disk/by-uuid/d1de16d2-c9fb-4b4d-b556-dc025596ab4f";
    fsType = "ext4";
    options = [ "nofail" "users" "auto" "exec" ];
    label = "HDD_1TB";
  };

  fileSystems."/mnt/NVME-1TB" = {
    device = "/dev/disk/by-uuid/f1dfa474-0c0d-4fba-8b95-72166e0b5649";
    fsType = "ext4";
    options = [ "nofail" "users" "auto" "exec" ];
    label = "NVME_1TB";
  };

}
