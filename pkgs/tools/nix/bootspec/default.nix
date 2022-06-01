{ lib
, fetchFromGitHub
, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "bootspec";
  version = "2022-05-31-unstable";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "bootspec";
    rev = "308253d2d1057ae217eabdaa3af269010435edce";
    sha256 = "sha256-LYhbRoujzR2sl5d4ew9oH+EFiqYjgzE/gwl1eAODcMU=";
  };

  cargoSha256 = "sha256-8TEaWWimHdGVFozPoKK4tL0a1usjwSGJtET7yFWawOA=";

  meta = with lib; {
    description = "Implementation of RFC-0125's datatype and synthesis tooling";
    homepage = "https://github.com/DeterminateSystems/bootspec";
    license = licenses.mit;
    maintainers = teams.determinatesystems.members;
  };
}
