{ rustPlatform
, cloud-utils
, fetchFromGitHub
, lib
, llvmPackages
, pkg-config
, util-linux
, zfs
}:
rustPlatform.buildRustPackage rec {
  pname = "zpool-auto-expand-partitions";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "zpool-auto-expand-partitions";
    rev = "07bd0e38419b623f037278705d897ef10813019c";
    hash = "sha256-LA6YO6vv7VCXwFfayQVxVR80niSCo89sG0hqh0wDEh8=";
  };

  cargoHash = "sha256-8ozM3MFnTHkQksfAg9/3+N/6vkSDFEqGC4L+g+HIZJI=";

  preBuild = ''
    substituteInPlace src/grow.rs \
      --replace '"growpart"' '"${cloud-utils}/bin/growpart"'
    substituteInPlace src/lsblk.rs \
      --replace '"lsblk"' '"${util-linux}/bin/lsblk"'
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    zfs.dev
    # util-linux # did not help: wrapper.h:1:10: fatal error: 'blkid/blkid.h' file not found
  ];

  # Helped with: set the `LIBCLANG_PATH` environment variable to a path where one of these files can be found
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
}

