function switch_theme --description "Switch system themes between dark and light"
    set theme $argv[1]

    if not contains -- "$theme" dark light
        echo "Usage: switch_theme dark|light"
        return 1
    end

    # Skip if theme is already active AND the live zellij config already reflects it
    # (guards against persisted-but-broken state where _switch_theme_active is set
    # but the on-disk configs hold empty values from a previous bad write).
    if test "$theme" = "$_switch_theme_active"
        set -l _expected_zj_theme "dracula"
        if test "$theme" = "light"
            set _expected_zj_theme "alucard"
        end
        if not test -f "$HOME/.config/zellij/config.kdl"
            # Config missing — fall through to (re)create it
        else if string match -rq "^theme \"$_expected_zj_theme\"" (cat "$HOME/.config/zellij/config.kdl")
            return 0
        end
        # else: file exists but theme line doesn't match — fall through to re-apply
    end

    # Use the absolute path to the dotfiles repo since realpath breaks inside the Nix store
    set -l _dotfiles "$HOME/Projects/nix-config/home/configs"

    # Use the global user gitconfig (not the tracked dotfile repo copy)
    set -l gitconfig "$HOME/.gitconfig"

    # Resolve lazygit config dir — macOS uses ~/Library/Application Support/lazygit,
    # Linux uses ~/.config/lazygit. Ask lazygit itself; fall back if not on PATH.
    set -l lazygit_dir (command -q lazygit; and lazygit --print-config-dir; or echo "$HOME/.config/lazygit")

    # ---------------------------------------------------------------------------
    # Palette — all color values in one place; branches below are code-only.
    # IMPORTANT: use set -f (function scope) not set -l (block scope) — block-scoped
    # vars are erased when the if/else closes and are invisible to the Apply section.
    # ---------------------------------------------------------------------------
    if test "$theme" = "dark"
        # Dracula Dark palette
        set -f p_normal      F8F8F2
        set -f p_command     8BE9FD
        set -f p_keyword     FF79C6
        set -f p_quote       F1FA8C
        set -f p_redirect    8BE9FD
        set -f p_end         FF79C6
        set -f p_error       FF5555
        set -f p_param       BD93F9
        set -f p_comment     6272A4
        set -f p_match_bg    brblue
        set -f p_sel_bg      brblack
        set -f p_search_fg   bryellow
        set -f p_operator    50FA7B
        set -f p_escape      FF79C6
        set -f p_cwd         50FA7B
        set -f p_cwd_root    red
        set -f p_autosugg    6272A4
        set -f p_user        brgreen
        set -f p_host        normal
        set -f p_pager_desc  B3A06D
        set -f p_pager_prog_fg brwhite
        set -f p_pager_prog_bg cyan
        set -f p_pager_compl normal
        set -f p_pager_sel_bg brblack
        set -f fzf_opts      "--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
        set -f h_pwd         bd93f9
        set -f h_git         50fa7b
        set -f h_error       ff5555
        set -f h_prompt      ff79c6
        set -f h_duration    f1fa8c
        set -f bat_theme     Dracula
        set -f delta_feature dracula
        set -f delta_dark    true
        set -f lazygit_theme "$_dotfiles/lazygit/theme-dark.yml"
        set -f lazydocker_theme "$_dotfiles/lazydocker/theme-dark.yml"
        set -f zellij_theme  dracula
        set -f yazi_theme    "$_dotfiles/yazi/theme-dark.toml"
        set -f btop_theme    dracula
        set -f k9s_skin      dracula
        set -f pgcli_theme   "$_dotfiles/pgcli/theme-dark"
        set -f tealdeer_theme "$_dotfiles/tealdeer/theme-dark.toml"
        set -f glamour_style "$_dotfiles/glamour/dracula.json"
        set -f agy_color_scheme solarized dark

    else
        # Alucard Light palette
        set -f p_normal      1F1F1F
        set -f p_command     036A96
        set -f p_keyword     A3144D
        set -f p_quote       846E15
        set -f p_redirect    036A96
        set -f p_end         A3144D
        set -f p_error       CB3A2A
        set -f p_param       644AC9
        set -f p_comment     6C664B
        set -f p_match_bg    CFCFDE
        set -f p_sel_bg      CFCFDE
        set -f p_search_fg   846E15
        set -f p_operator    14710A
        set -f p_escape      A3144D
        set -f p_cwd         14710A
        set -f p_cwd_root    CB3A2A
        set -f p_autosugg    6C664B
        set -f p_user        14710A
        set -f p_host        1F1F1F
        set -f p_pager_desc  846E15
        set -f p_pager_prog_fg FFFBEB
        set -f p_pager_prog_bg 036A96
        set -f p_pager_compl 1F1F1F
        set -f p_pager_sel_bg CFCFDE
        set -f fzf_opts      "--color=fg:#1f1f1f,bg:#fffbeb,hl:#644ac9 --color=fg+:#1f1f1f,bg+:#cfcfde,hl+:#644ac9 --color=info:#846e15,prompt:#14710a,pointer:#a3144d --color=marker:#a3144d,spinner:#846e15,header:#036a96"
        set -f h_pwd         644ac9
        set -f h_git         14710a
        set -f h_error       cb3a2a
        set -f h_prompt      a3144d
        set -f h_duration    846e15
        set -f bat_theme     Alucard
        set -f delta_feature alucard
        set -f delta_dark    false
        set -f lazygit_theme "$_dotfiles/lazygit/theme-light.yml"
        set -f lazydocker_theme "$_dotfiles/lazydocker/theme-light.yml"
        set -f zellij_theme  alucard
        set -f yazi_theme    "$_dotfiles/yazi/theme-light.toml"
        set -f btop_theme    alucard
        set -f k9s_skin      dracula
        set -f pgcli_theme   "$_dotfiles/pgcli/theme-light"
        set -f tealdeer_theme "$_dotfiles/tealdeer/theme-light.toml"
        set -f glamour_style "$_dotfiles/glamour/alucard.json"
        set -f agy_color_scheme solarized light

    end

    # ---------------------------------------------------------------------------
    # Apply — single code path for both themes
    # ---------------------------------------------------------------------------

    # Helper to set universal variable and erase any shadowing global variable
    function _set_u
        set -e -g $argv[1] 2>/dev/null
        set -U $argv[1] $argv[2..-1]
    end

    # Helper to set exported universal variable and erase any shadowing global variable
    function _set_ux
        set -e -g $argv[1] 2>/dev/null
        set -Ux $argv[1] $argv[2..-1]
    end

    # bat (-Ux so live-propagates to already-open shells, no restart needed)
    _set_ux BAT_THEME "$bat_theme"

    # Glamour (used by agy / Bubble Tea apps for markdown/diff rendering)
    _set_ux GLAMOUR_STYLE "$glamour_style"

    # agy (Antigravity CLI) — colorScheme in antigravity-cli/settings.json
    set -l _agy_settings "$HOME/.gemini/antigravity-cli/settings.json"
    if test -f "$_agy_settings"
        set -l _agy_tmp (mktemp)
        if jq --arg s "$agy_color_scheme" '.colorScheme = $s' "$_agy_settings" >"$_agy_tmp" 2>/dev/null
            mv "$_agy_tmp" "$_agy_settings"
        else
            rm -f "$_agy_tmp"
        end
    end

    # Git Delta
    git config --file "$gitconfig" delta.features "$delta_feature"
    git config --file "$gitconfig" delta.dark "$delta_dark"

    # Fish syntax highlighting
    _set_u fish_color_normal         $p_normal
    _set_u fish_color_command        $p_command
    _set_u fish_color_keyword        $p_keyword
    _set_u fish_color_quote          $p_quote
    _set_u fish_color_redirection    $p_redirect
    _set_u fish_color_end            $p_end
    _set_u fish_color_error          $p_error
    _set_u fish_color_param          $p_param
    _set_u fish_color_comment        $p_comment
    _set_u fish_color_match          --background=$p_match_bg
    _set_u fish_color_selection      $p_normal --bold --background=$p_sel_bg
    _set_u fish_color_search_match   $p_search_fg --background=$p_sel_bg
    _set_u fish_color_history_current --bold
    _set_u fish_color_operator       $p_operator
    _set_u fish_color_escape         $p_escape
    _set_u fish_color_cwd            $p_cwd
    _set_u fish_color_cwd_root       $p_cwd_root
    _set_u fish_color_valid_path     --underline
    _set_u fish_color_autosuggestion $p_autosugg
    _set_u fish_color_user           $p_user
    _set_u fish_color_host           $p_host
    _set_u fish_color_cancel         --reverse
    _set_u fish_pager_color_prefix              $p_normal --bold --underline
    _set_u fish_pager_color_progress            $p_pager_prog_fg --background=$p_pager_prog_bg
    _set_u fish_pager_color_completion          $p_pager_compl
    _set_u fish_pager_color_description         $p_pager_desc --style=italic
    _set_u fish_pager_color_selected_background --background=$p_pager_sel_bg

    # FZF and Hydro prompt colors
    _set_ux FZF_DEFAULT_OPTS  "$fzf_opts"
    _set_u hydro_color_pwd      $h_pwd
    _set_u hydro_color_git      $h_git
    _set_u hydro_color_error    $h_error
    _set_u hydro_color_prompt   $h_prompt
    _set_u hydro_color_duration $h_duration

    # Lazygit theme
    if test -f "$_dotfiles/lazygit/config-base.yml"
        mkdir -p "$lazygit_dir"
        cat "$_dotfiles/lazygit/config-base.yml" "$lazygit_theme" > "$lazygit_dir/config.yml"
    end

    # Lazydocker theme
    if test -f "$_dotfiles/lazydocker/config-base.yml"
        set -l lazydocker_dir "$HOME/Library/Application Support/lazydocker"
        test (uname) = Linux; and set lazydocker_dir "$HOME/.config/lazydocker"
        mkdir -p "$lazydocker_dir"
        cat "$_dotfiles/lazydocker/config-base.yml" "$lazydocker_theme" > "$lazydocker_dir/config.yml"
    end

    # Yazi theme
    if test -f "$yazi_theme"
        mkdir -p "$HOME/.config/yazi"
        cp "$yazi_theme" "$HOME/.config/yazi/theme.toml"
        if test -f "$_dotfiles/yazi/keymap.toml"
            cp "$_dotfiles/yazi/keymap.toml" "$HOME/.config/yazi/" 2>/dev/null
        end
    end

    # Btop theme
    mkdir -p "$HOME/.config/btop/themes"
    cp "$_dotfiles/btop/themes/"*.theme "$HOME/.config/btop/themes/" 2>/dev/null
    if test -f "$_dotfiles/btop/btop-base.conf"
        set -l _btop_tmp (mktemp)
        if grep -q "^color_theme =" "$_dotfiles/btop/btop-base.conf"
            string replace -r -- '^color_theme = .*' "color_theme = \"$btop_theme\"" < "$_dotfiles/btop/btop-base.conf" > "$_btop_tmp"
        else
            cat "$_dotfiles/btop/btop-base.conf" > "$_btop_tmp"
            echo "color_theme = \"$btop_theme\"" >> "$_btop_tmp"
        end
        mv "$_btop_tmp" "$HOME/.config/btop/btop.conf"
    end

    # K9s skin
    set -l k9s_dir "$HOME/Library/Application Support/k9s"
    test (uname) = Linux; and set k9s_dir "$HOME/.config/k9s"
    mkdir -p "$k9s_dir/skins"
    cp "$_dotfiles/k9s/skins/"*.yaml "$k9s_dir/skins/" 2>/dev/null
    if test -f "$_dotfiles/k9s/config-base.yaml"
        set -l _k9s_tmp (mktemp)
        if grep -q "skin:" "$_dotfiles/k9s/config-base.yaml"
            string replace -r -- 'skin: .*' "skin: $k9s_skin" < "$_dotfiles/k9s/config-base.yaml" > "$_k9s_tmp"
        else
            awk -v skin="$k9s_skin" '
                /^  ui:/ { print; print "    skin: " skin; injected=1; next }
                { print }
                END { if (!injected) { print "  ui:"; print "    skin: " skin } }
            ' "$_dotfiles/k9s/config-base.yaml" > "$_k9s_tmp"
        end
        mv "$_k9s_tmp" "$k9s_dir/config.yaml"
    end

    # pgcli theme
    if test -f "$_dotfiles/pgcli/config-base"
        mkdir -p "$HOME/.config/pgcli"
        cat "$_dotfiles/pgcli/config-base" "$pgcli_theme" > "$HOME/.config/pgcli/config"
    end

    # tealdeer theme
    if test -f "$_dotfiles/tealdeer/config-base.toml"
        mkdir -p "$HOME/.config/tealdeer"
        cat "$_dotfiles/tealdeer/config-base.toml" "$tealdeer_theme" > "$HOME/.config/tealdeer/config.toml"
    end

    # Zellij theme (live hot-swap — Zellij reloads config.kdl automatically on macOS,
    # but on Linux cat > truncates and might panic the watcher. We rely on action broadcast below).
    if test -f "$_dotfiles/zellij/config-base.kdl"
        mkdir -p "$HOME/.config/zellij"
        cp -r "$_dotfiles/zellij/themes" "$HOME/.config/zellij/" 2>/dev/null
        set -l _zj_cfg "$HOME/.config/zellij/config.kdl"
        set -l _zj_tmp (mktemp)
        string replace -r -- '^theme .*' "theme \"$zellij_theme\"" < "$_dotfiles/zellij/config-base.kdl" > "$_zj_tmp"
        mv "$_zj_tmp" "$_zj_cfg"
    end

    if command -q zellij
        set -l zj_action "set-dark-theme"
        if test "$theme" = "light"
            set zj_action "set-light-theme"
        end
        for session in (zellij list-sessions -n 2>/dev/null | awk '{print $1}')
            zellij --session "$session" action "$zj_action" 2>/dev/null
        end
    end

    set -U _switch_theme_active "$theme"
    functions --erase _set_u _set_ux
end
