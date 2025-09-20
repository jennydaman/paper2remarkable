{
  description = "Fetch an academic paper or web article and send it to the reMarkable tablet with a single command.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) { inherit system; };
      in
      with pkgs;
      {
        packages.default = python3Packages.buildPythonPackage {
          pname = "paper2remarkable";
          version = lib.pipe (builtins.readFile ./paper2remarkable/__version__.py) [
            (lib.strings.splitString "\n")
            (lib.lists.findFirst (lib.hasPrefix "VERSION = (") "VERSION = (0, 0, 0)")
            (lib.removePrefix "VERSION = (")
            (lib.removeSuffix ")")
            (lib.replaceStrings [", "] ["."])
          ];
          src = ./.;
          format = "setuptools";
          propagatedBuildInputs = [
            pdftk
            ghostscript
            rmapi
            python3Packages.beautifulsoup4
            python3Packages.html2text
            python3Packages.lxml-html-clean
            python3Packages.markdown
            python3Packages.pdfplumber
            python3Packages.pikepdf
            python3Packages.pycryptodome
            python3Packages.pyyaml
            python3Packages.readability-lxml
            python3Packages.regex
            python3Packages.requests
            python3Packages.titlecase
            python3Packages.unidecode
            python3Packages.validators
            python3Packages.weasyprint
          ];
          meta.mainProgram = "p2r";
        };
      });
}
