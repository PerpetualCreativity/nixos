{
  pkgs,
  ...
}:
{
  home = {
    username = "vulcan";
    homeDirectory = "/home/vulcan";
    packages = with pkgs; [
      ripgrep
      fd
      fzf
      zoxide
      entr
      jq
      hyperfine
      sl
      unzip
      difftastic

      nil
      nix-your-shell

      sshfs
    ];

    stateVersion = "24.05"; # do not change
  };

  programs = {
    ssh = {
      enable = true;
      matchBlocks = {
        ice = {
          host = "ice";
          user = "vthiru3";
          hostname = "login-ice.pace.gatech.edu";
        };
        rohansrv = {
          host = "rohansrv";
          user = "vulcan";
          hostname = "bafna.dev";
          port = 52932;
        };
      };
    };
    git = {
      enable = true;
      ignores = [
        ".stfolder/"
        ".envrc"
      ];
      userEmail = "47309279+PerpetualCreativity@users.noreply.github.com";
      userName = "Ved Thiru";
      extraConfig = {
        safe.directory = "/home/vulcan/nixos/.git";
        help.autocorrect = "prompt";
      };
      difftastic = {
        enable = true;
        display = "inline";
      };
    };
    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
        hosts = [
          "https://github.com"
          "https://gist.github.com"
          "https://github.gatech.edu"
        ];
      };
    };
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "rose_pine_moon";
        editor = {
          line-number = "relative";
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          idle-timeout = 100;
          soft-wrap.enable = true;
          cursorline = true;
          color-modes = true;
          cursor-shape = {
            insert = "bar";
            normal = "underline";
            select = "block";
          };
          indent-guides.render = true;
          statusline = {
            left = [
              "mode"
              "spacer"
              "spinner"
              "diagnostics"
            ];
            center = [
              "version-control"
              "file-name"
              "read-only-indicator"
              "file-modification-indicator"
            ];
            right = [
              "workspace-diagnostics"
              "spacer"
              "selections"
              "spacer"
              "position-percentage"
            ];
          };
        };
      };
    };
    fish = {
      enable = true;
      shellAliases = {
        h = "hx .";
        py = "python3";
        sl = "sl -wG";
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
          set -g __fish_git_prompt_use_informative_chars false
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
          test $last_status -ne 0; and echo (set_color red --bold)" [$last_status]"(set_color normal)
          test $SHLVL -ne 1; and echo (set_color magenta --bold)" ($(math $SHLVL - 1))"(set_color normal)
          if test -n "$IN_NIX_SHELL"
            echo (set_color blue --bold)' <'(set_color --italics)'devshell'(set_color --bold)'>'(set_color normal)
          else if echo $PATH | grep -qc /nix/store
            echo (set_color blue --bold)' <'(set_color --italics)'nix shell'(set_color --bold)'>'(set_color normal)
          end
        '';
        fish_greeting = ''
          if not set -q $SILENCE_GREETING
            set files (snow check)
            test $status -ne 0; and echo "configs newer than last rebuild:" $files
          end
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
