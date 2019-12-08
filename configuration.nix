{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  fonts = {
    fonts = with pkgs; [
      iosevka
      siji
      hasklig
      scientifica
      fira-code
      font-awesome_5
      emacs-all-the-icons-fonts
      xorg.fontarabicmisc
    ];
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    termite
    qutebrowser
    (pkgs.callPackage config/vim.nix {})
    emacs
    discord
    mpd
    ncmpcpp
    godot
  ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.tmux = {
    enable = true;
    extraTmuxConf = ''
      source-file /home/gulkbag/.tmux-themepack/powerline/double/yellow.tmuxtheme

      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      unbind z
      unbind x
      bind z split-window -h
      bind x split-window -v
      bind e kill-pane

      bind -n C-j run-shell "tmux previous-window"
      bind -n C-k run-shell "tmux next-window"
      bind -n C-n run-shell "tmux kill-session"
    '';
    escapeTime = 0;
  };

  # Brightness
  programs.light.enable = true;

  # Sway
  programs.sway.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  # For steam
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  nixpkgs.config = {
    allowUnfree = true;
    emacs = pkgs.lib.overrideDerivation (pkgs.emacs.override {
      # Use gtk3 instead of the default gtk2
      gtk = pkgs.gtk3;
      # Make sure imagemgick is a dependency because I regularly
      # look at pictures from Emasc
      imagemagick = pkgs.imagemagickBig;
    }) (attrs: {
      # I don't want emacs.desktop file because I only use
      # emacsclient.
      postInstall = attrs.postInstall + ''
            '';
    });
  };

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "gulkbag" ];

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql;
  services.postgresql.enableTCPIP = true;
  services.postgresql.authentication = pkgs.lib.mkOverride 10 ''
    local all all trust
    host all all ::1/128 trust
  '';

  users.users.gulkbag = {
    isNormalUser = true;
    shell = pkgs.ksh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  system.stateVersion = "19.03";
}
