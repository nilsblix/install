{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

        sfmono.url = "github:nilsblix/sf-mono-nf";
    };

    outputs = { ... }@inputs: let
        system = "aarch64-darwin";
    in {
        darwinConfigurations."nilsblix" = inputs.nix-darwin.lib.darwinSystem {
            modules = [
                ({ pkgs, ... }: {
                    nixpkgs.hostPlatform = system;
                    nixpkgs.config.allowUnfree = true;

                    system.primaryUser = "nilsblix";
                    system.stateVersion = 5;
                    ids.gids.nixbld = 350;

                    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
                    nix.settings = {
                        trusted-users = [ "nilsblix" ];
                        extra-substituters = [
                            "https://nix-community.cachix.org"
                            "https://cache.numtide.com"
                        ];
                        extra-trusted-public-keys = [
                            "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
                        ];
                    };
                    nix.extraOptions = ''
                        experimental-features = nix-command flakes
                    '';

                    environment.shells = with pkgs; [
                        bash
                        zsh
                        fish
                    ];

                    environment.systemPackages = with pkgs; [
                        btop
                        direnv
                        dust
                        fd
                        fish
                        fzf
                        gh
                        git
                        nixd
                        pam-reattach
                        ripgrep
                        tree
                        vim
                        wget
                        yazi

                        # Desktop apps
                        firefox
                        ghostty-bin
                        karabiner-elements
                        signal-desktop
                        spotify
                        raycast
                    ];

                    networking = {
                        computerName = "Nils's Macbook Pro 14";
                        hostName = "box";
                        localHostName = "nilsblix-mbp2021";
                    };

                    security.pam.services.sudo_local = {
                        touchIdAuth = true;
                        reattach = true;
                    };

                    fonts.packages = with pkgs; [
                        nerd-fonts.jetbrains-mono
                        source-code-pro
                        plemoljp-nf
                        inputs.sfmono.packages.${pkgs.stdenv.hostPlatform.system}.default
                    ];
                })
            ];
        };
    };
}
