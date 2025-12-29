{
  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs.git?ref=nixos-unstable&shallow=1";
  };

  outputs =
    { self, nixpkgs }:
    {
      nixosConfigurations = {
        kexec-x86_64 = nixpkgs.lib.nixosSystem {
          modules = [
            ./initrd.nix
            { nixpkgs.hostPlatform = "x86_64-linux"; }
          ];
        };

        kexec-aarch64 = nixpkgs.lib.nixosSystem {
          modules = [
            ./initrd.nix
            { nixpkgs.hostPlatform = "aarch64-linux"; }
          ];
        };

        host-example = nixpkgs.lib.nixosSystem {
          modules = [
            ./host.nix
          ];
        };
      };

    };
}
