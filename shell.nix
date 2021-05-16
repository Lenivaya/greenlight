{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShell {
  buildInputs = [
    # Go lsp server
    gopls

    # Sql formatting
    python37Packages.sqlparse
  ];
}
