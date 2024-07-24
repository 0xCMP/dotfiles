{ config, lib, pkgs, ... }:
let
  cfg = config.chrisportela.gaming;
in
with lib; {
  options.chrisportela.gaming = {
    enable = lib.mkEnableOption "Gaming config";
    # nvidia = lib.mkEnableOption "Nvidia specific settings";
  };

  config = mkIf cfg.enable {
    import = [
      inputs.nix-gaming.nixosModules.steamCompat
    ];

    nix.settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "nvidia-persistenced"
      "nvidia-settings"
      "nvidia-x11"
    ];
    # NVIDIA drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.opengl.enable = true;

    # Extra OpenGL options
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    hardware.opengl.setLdLibraryPath = true;
    hardware.opengl.driSupport32Bit = true;

    environment.systemPackages = with pkgs; [
      (lutris.override {
        extraLibraries = pkgs: [ ];
      })
      goverlay
      mangohud
      protonup
      vulkan-tools
    ];

    # hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      extest.enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      # gamescopeSession.args = ["--prefer-vk-device 8086:9bc4"];
      extraCompatPackages = [
        inputs.nix-gaming.packages.${system}.proton-ge
        # TODO: https://github.com/iggut/home/blob/c79cf231f3fd24af94437a6824a0dfd416e083dd/system/programs/self-built/proton-ge.nix
      ];
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = 10;
        };
        custom = {
          start = "notify-send -a 'Gamemode' 'Optimizations activated'";
          end = "notify-send -a 'Gamemode' 'Optimizations deactivated'";
        };
      };
    };

    #Enable Gamescope
    programs.gamescope = {
      enable = true;
      package = pkgs.gamescope_git;
      capSysNice = true;
      # args = ["--prefer-vk-device 8086:9bc4"];
    };

    environment.sessionVariables = {
      STEAM_FORCE_DESKTOPUI_SCALING = "2";
      NIXOS_OZONE_WL = "1";
    };

  };
}
