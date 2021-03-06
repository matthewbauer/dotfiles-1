# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  nixpkgs.config.chromium = {
      # https://github.com/NixOS/nixpkgs/issues/22333
      enableWideVine = false;
  };

  time.timeZone = "America/New_York";

  # Use the gummiboot efi boot loader.
  boot = {
    #kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;


    # sadly some important applications, such as firefox, behave poorly
    # with overcommit disabled.
    #kernel.sysctl = {
    #  "vm.overcommit_memory" = 2; # disable overcommit

    #};

    # Power saving
    #kernelParams = [
    #  "pcie_aspm=force"
    #  "i915.enable_psr=1"
    #  "i915.enable_fbc=1"
    #  "i915.enable_rc6=7"
    #];
  };

  networking = {
    hostName = "xps";
    networkmanager.enable = true;
    enableB43Firmware = true;
  };

  hardware = {
    enableAllFirmware = true;
    opengl = {
      driSupport32Bit = true;
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };
  };

  virtualisation.virtualbox.host.enable = false;
  #nixpkgs.config.virtualbox.enableExtensionPack = false;

  #virtualisation.docker.enable = true;
  #virtualisation.docker.enableOnBoot = true;

  services = {
    ntp.enable = true;
    locate.enable = true;
    dbus.enable = true;
    udisks2.enable = true;
    udev.packages = [ pkgs.libmtp.bin ];
    udev.extraRules = ''
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
    '';
  };

  services.xserver = {
    enable = true;
    #videoDrivers = [ "nvidia" ];
    layout = "us";
    xkbOptions = "eurosign:e";
    synaptics = {
      enable = true;
      twoFingerScroll = true;
      additionalOptions = ''
        Option "ClickPad" "true"
        Option "EmulateMidButtonTime" "0"
        Option "SoftButtonAreas" "50% 0 82% 0 0 0 0 0"
      '';
    };
    desktopManager.xterm.enable = false;
    desktopManager.xfce.enable = true;
  };

  security = {
    sudo.enable = true;
    sudo.wheelNeedsPassword = false;
    rtkit.enable = true;

    pam.loginLimits = [
      { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
      { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
      { domain = "@audio"; item = "nofile"; type = "soft"; value = "99999"; }
      { domain = "@audio"; item = "nofile"; type = "hard"; value = "99999"; }
    ];
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    #ardour
    #audacity
    bind
    #blender
    cargo
    chromium
    clang
    colordiff
    #cowsay
    #ddd
    #docker
    file
    firefox
    fzf
    gcolor2
    gimp
    git
    git-hub
    gitAndTools.git-extras
    gcc
    gdb
    glxinfo
    gnupg1
    gparted
    #handbrake
    hexchat
    htop
    inkscape
    iotop
    jack2Full
    jmtpfs
    kitty
    libnotify
    libreoffice
    lsof
    manpages
    mpv
    mupdf
    networkmanagerapplet
    pciutils
    nodejs
    nox
    obs-studio
    p7zip
    pavucontrol
    #pidgin
    powertop
    psmisc
    python
    python3
    qjackctl
    ruby
    rustc
    s3cmd
    simplescreenrecorder
    subversionClient
    #synthv1
    telnet
    thunderbird
    unrar
    unzip
    upx
    valgrind
    vlc
    wget
    xdg-user-dirs
    xlibs.xev
    xfce.thunar_volman
    xfce.xfce4_systemload_plugin
    xfce.xfce4_cpufreq_plugin
    xfce.xfce4_cpugraph_plugin
    xfce.xfce4_power_manager
    xfce.xfce4taskmanager
    xlockmore
    zip
  ];


  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.andy = {
    isNormalUser = true;
    description = "Andrew Kelley";
    extraGroups = [ "wheel"  "networkmanager" "video" "power" "vboxusers" "audio" "docker" ];
    uid = 1000;
  };
  users.extraUsers.alee = {
    isNormalUser = true;
    description = "Alexandra Gillis";
    extraGroups = [ "networkmanager" "video" "power" "audio" ];
    uid = 1001;
  };
  users.defaultUserShell = "/run/current-system/sw/bin/fish";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
