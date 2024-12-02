{ config, pkgs, ... }:

{
  users.groups.mediacenter = {
    gid = 13000;
  };

  users.users.mediapod = {
    uid = 13001;
    isSystemUser = true;
    group = "mediacenter";
  };
}
