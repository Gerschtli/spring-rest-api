let
  app = import ./..;
  uid = 1100;
  description = "Spring Rest API application";
in

{
  network = {
    inherit description;
    enableRollback = true;
  };

  ${app.name} =
    { lib, pkgs, ... }:
    {
      deployment = {
        targetEnv = "container";
        container.host = "app.${app.name}";
      };

      networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 8080 ];
        allowPing = true;
      };

      systemd.services.${app.name} = {
        inherit description;
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "${app}/bin/${app.name}";
          User = app.name;
          Restart = "always";
        };
      };

      time.timeZone = "Europe/Berlin";

      users = {
        groups.${app.name}.gid = uid;

        users.${app.name} = {
          inherit uid;
          group = app.name;
        };
      };
    };
}
