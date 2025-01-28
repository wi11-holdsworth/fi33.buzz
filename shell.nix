{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs.buildPackages; [ 
      gnumake 
      envsubst 
      python312Packages.mat2
    ];
}
