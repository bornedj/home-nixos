{
  pkgs,
}:

pkgs.vimUtils.buildVimPlugin {
    name = "vim-dadbod-ui";
    src = pkgs.fetchFromGitHub {
        owner = "bornedj";
        repo = "vim-dadbod-ui";
        rev = "fix/oracle-table-name-truncation-237";
        hash = "sha256-C3eR5PfOd/RRlQVEUcPpd/XyelPP6jPrbtGhcIzN0lU=";
    };
}

