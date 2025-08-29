# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  #mount
  fileSystems."/media/win11" = {
    device = "/dev/disk/by-uuid/B4D6BBACD6BB6D6C";
    fsType = "ntfs-3g";
    options = [ "nofail" "x-systemd.device-timeout=5s" "uid=1000" "gid=100" "umask=0022"];
  };
  fileSystems."/media/school" = {
    device = "/dev/disk/by-uuid/A094DAFE94DAD5BE";
    fsType = "ntfs-3g";                
    options = [ "nofail" "x-systemd.device-timeout=5s" "uid=1000" "gid=100" "umask=0022"];
  };

  #swap
    swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16GB
  }];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Set your time zone.
  security.rtkit.enable = true;  
  services.chrony.enable = true; 
  services.automatic-timezoned.enable = true;
  services.tzupdate.enable = true;

  # fingerprint sensor
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

   
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  # Enable the LXQT & KDE Desktop Environment.
	#LXQT
    services.xserver.displayManager.lightdm.enable = false;
    services.xserver.desktopManager.lxqt.enable = false;
        #KDE
    services.xserver.desktopManager.plasma5.enable = false;
    services.displayManager.sddm.enable = false;

  # Configure keymap in wayland
  services.xserver = {
  	xkb = {
    		layout = "us,es";
    		variant = "";        
    		options = "grp:win_space";
  	};
  };

  # when da lid is shut
  services.logind.lidSwitch = "lock"; # or "poweroff", "suspend", or "ignore" or "logout"

  services.logind.extraConfig = ''
       HandlePowerKey=ignore
    '';


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.dbus.enable = true;
  environment.etc."wireplumber/bluetooth.lua.d/50-bluez-config.lua".text = ''
  bluez_monitor.properties = {
    ["bluez5.enable-msbc"] = true,
    ["bluez5.enable-hw-volume"] = true,
    ["bluez5.codecs"] = { "sbc", "aac", "ldac", "aptx", "aptx-hd", "msbc" },
    }
  '';


  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber.enable = true;
    
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jax = {
    isNormalUser = true;
    description = "jax";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  #allow close source and paid programs 
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
        hyprland
	hyprlock #lockscreen  
        kitty    
        rofi-wayland
	swaynotificationcenter
	waybar   
	networkmanager
	networkmanagerapplet
	eww
	brightnessctl   
        firefox
	google-chrome
	fastfetch
	ntfs3g
	git
	font-manager
 	pavucontrol #audio
	pulseaudio #audio
	playerctl
	xkeyboard_config
	fprintd #fingerprint
	ulauncher #----#search
	gparted #------#disk manager
	yazi #---------------#file manager
        nemo-with-extensions #file manager
	libsForQt5.okular #--------------#PDF viewer
	libsForQt5.kate #----------------#text editor
	zip #----------------------------#zip
	unzip #--------------------------#unzip
	qimgv #--------------------------#image viewer
	vlc #----------------------------#media player
	audacity #-----------------------#music
        slurp #--------------------------#screenshots
	grim #---------------------------#screenshots
	btop #---------#system manger
	swww #---------#background image
	nwg-look #-----#icon logo things 
	bibata-cursors #---------------#cursor
	dracula-icon-theme #-----------#icon
	gnome-themes-extra #-----------#theme
	materia-theme #----------------#theme
	vscode-fhs ##MS code
	wpsoffice ##excel
	protonvpn-gui ##VPN
	ncmpcpp #--#music
	mdp #------#music
	spotify #--#music
	qalculate-gtk ##Calculator	

  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # fonts, but more
  fonts.packages = with pkgs; [
	#	(nerdfonts.override { fonts = [ "materialicons" "fontlogos" ]; })
	#	font-logos
	#	material-icons
	material-design-icons
	nerd-fonts.symbols-only
   	];

  environment.variables = {
	XCURSOR_THEME = "Bibata-Modern-Classic";
	XCURSOR_SIZE = "20";
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
 
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    };
  };

  # Enable greetd (minimal login manager)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # Hyprland direct launch
        command = "Hyprland";
        user = "jax"; # Replace with your actual user
      };
    };
  };

  #list services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
