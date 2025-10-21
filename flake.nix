{
  description = "RJG shared Nix helpers";

  # it is common practice to override this in the consumer by setting
  #  'inputs.ci.inputs.nixpkgs.follows = "your nixpkgs"'
  # so that an additional instance of nixpkgs is not required for evaluation
  #
  # see https://zimbatm.com/notes/1000-instances-of-nixpkgs for additional information
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

  outputs =
    { self, nixpkgs, ... }:
    let
      getDebianVersion = import ./lib/get-debian-version.nix;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;

      # public interface
      overlays.default = final: prev: {
        lib = prev.lib // {
          inherit getDebianVersion;
        };
      };
    };
}
