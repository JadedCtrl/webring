self: { config, lib, options, ... }:
with lib;
let cfg = config.casuallyblue.services.webring; in
{
  options = {
    casuallyblue.services.webring = {
      enable = mkEnableOption "webring.casuallyblue.dev server";

      hostname = mkOption {
        type = types.str;
        default = "webring.casuallyblue.dev";
        description = "The hostname to serve on";
      };
    };
  };

  config = mkIf cfg.enable {
    services.nginx.enable = true;
    services.nginx.virtualHosts."${cfg.hostname}" = {
      forceSSL = true;
      enableACME = true;
      root = self.packages.x86_64-linux.default;
    };
  };
}
