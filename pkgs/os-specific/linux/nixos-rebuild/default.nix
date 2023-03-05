{ substituteAll
, runtimeShell
, coreutils
, gnused
, gnugrep
, nix
, nix3_build ? "${nix}/bin/nix \"\${flakeFlags[@]}\" build"
, nix3_copy ? "${nix}/bin/nix \"\${flakeFlags[@]}\" copy"
, nix3_edit ? "${nix}/bin/nix \"\${flakeFlags[@]}\" edit"
, nix3_eval ? "${nix}/bin/nix \"\${flakeFlags[@]}\" eval"
, nix_build ? "${nix}/bin/nix-build"
, nix_channel ? "${nix}/bin/nix-channel"
, nix_copy_closure ? "${nix}/bin/nix-copy-closure"
, nix_env ? "${nix}/bin/nix-env"
, nix_instantiate ? "${nix}/bin/nix-instantiate"
, nix_store ? "${nix}/bin/nix-store"
, fallbackPaths ? ./../../../../nixos/modules/installer/tools/nix-fallback-paths.nix
, lib
, nixosTests
}:
let
  fallback = import fallbackPaths;
in
substituteAll {
  name = "nixos-rebuild";
  src = ./nixos-rebuild.sh;
  dir = "bin";
  isExecutable = true;
  inherit
    runtimeShell nix3_build nix3_copy nix3_edit nix3_eval nix_build
    nix_channel nix_copy_closure nix_env nix_instantiate nix_store;
  nix_x86_64_linux = fallback.x86_64-linux;
  nix_i686_linux = fallback.i686-linux;
  nix_aarch64_linux = fallback.aarch64-linux;
  path = lib.makeBinPath [ coreutils gnused gnugrep ];

  # run some a simple installer tests to make sure nixos-rebuild still works for them
  passthru.tests = {
    simple-installer = nixosTests.installer.simple;
    specialisations = nixosTests.nixos-rebuild-specialisations;
  };

  meta = {
    description = "Rebuild your NixOS configuration and switch to it, on local hosts and remote.";
    homepage = "https://github.com/NixOS/nixpkgs/tree/master/pkgs/os-specific/linux/nixos-rebuild";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.Profpatsch ];
    mainProgram = "nixos-rebuild";
  };
}
