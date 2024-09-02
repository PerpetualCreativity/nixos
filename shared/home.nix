{ config, pkgs, ... }:

{

  home = {
    username = "vulcan";
    homeDirectory = "/home/vulcan";
    packages = with pkgs; [
      gh
      ripgrep fd
      fzf
      zoxide
      entr
      jq

      nil nix-your-shell
    ];

    stateVersion = "24.05"; # do not change
  };

  programs = {
    git = {
      enable = true;
      ignores = [ ".stfolder/" ];
    };
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "flatwhite";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
          idle-timeout = 100;
          soft-wrap.enable = true;
          cursorline = true;
          color-modes = true;
          cursor-shape = {
            insert = "bar";
            normal = "underline";
            select = "block";
          };
          statusline = {
            left = ["mode" "spacer" "spinner" "diagnostics"];
            center = ["version-control" "file-name" "file-modification-indicator"];
            right = ["selections" "spacer" "position-percentage"];
          };
        };
      };
    };
    fish = {
      enable = true;
      shellAliases = {
        h = "hx .";
        py = "python3";
      };
      functions = {
        mkcd = "mkdir $argv[1]; and cd $argv[1]";
        cls = "cd $argv[1]; and ls";
        notes = "hx ~/notes/$argv[1].md";
        trash = ''
          mv $argv[1] ~/Trash
          echo "entries in ~/Trash: $(ls -a1 | count)"
        '';
        fish_prompt = ''
          set -g __fish_git_prompt_show_informative_status true
          set -g __fish_git_prompt_showuntrackedfiles true
          set -g __fish_git_prompt_showcolorhints true
          set -g __fish_git_prompt_char_stateseparator ' '
          set -g __fish_git_prompt_color brblack
          echo -sn (set_color magenta) $USER (set_color brblack) '@' (set_color green) (prompt_hostname) ' ' (set_color cyan) (prompt_pwd) (fish_git_prompt)
          if fish_is_root_user
              echo -n (set_color red --bold)' $ '
          else
              echo -n (set_color blue)' > '
          end
          set_color normal
        '';
        fish_right_prompt = ''
          set -l last_status $status
          test -n "$IN_NIX_SHELL"; and echo (set_color blue --bold)'<'(set_color --italics)'devshell'(set_color --bold)'>'(set_color normal)
          if test $last_status -ne 0
              echo (set_color red --bold)" [$last_status]"(set_color normal)
          end
        '';
        fish_greeting = ''
          set files (snow check)
          test $status -ne 0; and echo "configs newer than last rebuild:" $files
        '';
      };
      shellInit = ''
        if command -q nix-your-shell
          nix-your-shell fish | source
        end
      '';
      interactiveShellInit = ''
        zoxide init fish --cmd cd | source
        fish_add_path ~/bin ~/nixos/bin
      '';
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    home-manager.enable = true;
  };
}
