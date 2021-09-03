{ lib
, rustPlatform
, fetchFromGitHub
, coreutils
, bash
, cpio
, nix
, zstd
, which
}:
rustPlatform.buildRustPackage rec {
  pname = "nix-netboot-serve";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = pname;
    rev = "v${version}";
    sha256 = "Ij2isoS4Gy7T2dKELUR6GfjoqKYmXYZV4OdrqFePwGw=";
  };

  # required for the build.rs script
  nativeBuildInputs = [
    coreutils
    bash
    cpio
    nix
    zstd.bin
    which
  ];

  cargoLock.lockFile = src + "/Cargo.lock";

  meta = with lib; {
    description = "Make any NixOS system netbootable with 10s cycle times";
    homepage = "https://github.com/DeterminateSystems/nix-netboot-serve";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}
