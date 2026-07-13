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
        set -l _expected_zj_theme gruvbox-dark
        if test "$theme" = light
            set _expected_zj_theme gruvbox-light
        end
        if not test -f "$HOME/.config/zellij/config.kdl"
            # Config missing — fall through to (re)create it
        else if string match -rq "^theme \"$_expected_zj_theme\"" (cat "$HOME/.config/zellij/config.kdl")
            return 0
        end
        # else: file exists but theme line doesn't match — fall through to re-apply
    end

    # Use FLAKE_PATH if available, otherwise fallback to hardcoded path to prevent silent failures
    set -l _dotfiles "$FLAKE_PATH/home/configs"

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
    if test "$theme" = dark
        # Gruvbox Material Dark (Hard)
        set -f p_normal e2cca9
        set -f p_command 89b482
        set -f p_keyword d3869b
        set -f p_quote d8a657
        set -f p_redirect e2cca9
        set -f p_end e78a4e
        set -f p_error ea6962
        set -f p_param 7daea3
        set -f p_comment 928374
        set -f p_match_bg 3c3836
        set -f p_sel_bg 504945
        set -f p_search_fg e2cca9
        set -f p_operator e78a4e
        set -f p_escape d3869b
        set -f p_cwd 7daea3
        set -f p_cwd_root ea6962
        set -f p_autosugg 928374
        set -f p_user a9b665
        set -f p_host e2cca9
        set -f p_pager_desc 928374
        set -f p_pager_prog_fg e2cca9
        set -f p_pager_prog_bg 3c3836
        set -f p_pager_compl e2cca9
        set -f p_pager_sel_bg 504945
        set -f fzf_opts "--color=fg:#e2cca9,bg:#1d2021,hl:#89b482 --color=fg+:#e2cca9,bg+:#3c3836,hl+:#89b482 --color=info:#e78a4e,prompt:#89b482,pointer:#ea6962 --color=marker:#ea6962,spinner:#ea6962,header:#a9b665"
        set -f h_pwd 7daea3
        set -f h_git a9b665
        set -f h_error ea6962
        set -f h_prompt d3869b
        set -f h_duration d8a657
        set -f bat_theme gruvbox-dark
        set -f delta_feature gruvbox-material-dark
        set -f delta_dark true
        set -f lazygit_theme "$_dotfiles/lazygit/theme-dark.yml"
        set -f lazydocker_theme "$_dotfiles/lazydocker/theme-dark.yml"
        set -f zellij_theme gruvbox-dark
        set -f yazi_theme "$_dotfiles/yazi/theme-dark.toml"
        set -f btop_theme gruvbox_material_dark
        set -f k9s_skin gruvbox-material-dark
        set -f pgcli_theme "$_dotfiles/pgcli/theme-dark"
        set -f tealdeer_theme "$_dotfiles/tealdeer/theme-dark.toml"
        set -f glamour_style "$_dotfiles/glamour/gruvbox-material-dark.json"
    else
        # Gruvbox Material Light (Hard)
        set -f p_normal 514036
        set -f p_command 4c7a5d
        set -f p_keyword 945e80
        set -f p_quote b47109
        set -f p_redirect 514036
        set -f p_end c35e0a
        set -f p_error c14a4a
        set -f p_param 45707a
        set -f p_comment 7c6f64
        set -f p_match_bg f2e5bc
        set -f p_sel_bg ebdbb2
        set -f p_search_fg 514036
        set -f p_operator c35e0a
        set -f p_escape 945e80
        set -f p_cwd 45707a
        set -f p_cwd_root c14a4a
        set -f p_autosugg 7c6f64
        set -f p_user 6c782e
        set -f p_host 514036
        set -f p_pager_desc 7c6f64
        set -f p_pager_prog_fg 514036
        set -f p_pager_prog_bg f2e5bc
        set -f p_pager_compl 514036
        set -f p_pager_sel_bg ebdbb2
        set -f fzf_opts "--color=fg:#514036,bg:#f9f5d7,hl:#45707a --color=fg+:#514036,bg+:#ebdbb2,hl+:#45707a --color=info:#c35e0a,prompt:#4c7a5d,pointer:#c14a4a --color=marker:#c14a4a,spinner:#c14a4a,header:#6c782e"
        set -f h_pwd 45707a
        set -f h_git 6c782e
        set -f h_error c14a4a
        set -f h_prompt 945e80
        set -f h_duration b47109
        set -f bat_theme gruvbox-light
        set -f delta_feature gruvbox-material-light
        set -f delta_dark false
        set -f lazygit_theme "$_dotfiles/lazygit/theme-light.yml"
        set -f lazydocker_theme "$_dotfiles/lazydocker/theme-light.yml"
        set -f zellij_theme gruvbox-light
        set -f yazi_theme "$_dotfiles/yazi/theme-light.toml"
        set -f btop_theme gruvbox_light
        set -f k9s_skin gruvbox-material-dark
        set -f pgcli_theme "$_dotfiles/pgcli/theme-light"
        set -f tealdeer_theme "$_dotfiles/tealdeer/theme-light.toml"
        set -f glamour_style "$_dotfiles/glamour/gruvbox-material-light.json"
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

    # Git Delta
    git config --file "$gitconfig" delta.features "$delta_feature"
    git config --file "$gitconfig" delta.dark "$delta_dark"

    # Fish syntax highlighting
    _set_u fish_color_normal $p_normal
    _set_u fish_color_command $p_command
    _set_u fish_color_keyword $p_keyword
    _set_u fish_color_quote $p_quote
    _set_u fish_color_redirection $p_redirect
    _set_u fish_color_end $p_end
    _set_u fish_color_error $p_error
    _set_u fish_color_param $p_param
    _set_u fish_color_comment $p_comment
    _set_u fish_color_match --background=$p_match_bg
    _set_u fish_color_selection $p_normal --bold --background=$p_sel_bg
    _set_u fish_color_search_match $p_search_fg --background=$p_sel_bg
    _set_u fish_color_history_current --bold
    _set_u fish_color_operator $p_operator
    _set_u fish_color_escape $p_escape
    _set_u fish_color_cwd $p_cwd
    _set_u fish_color_cwd_root $p_cwd_root
    _set_u fish_color_valid_path --underline
    _set_u fish_color_autosuggestion $p_autosugg
    _set_u fish_color_user $p_user
    _set_u fish_color_host $p_host
    _set_u fish_color_cancel --reverse
    _set_u fish_pager_color_prefix $p_normal --bold --underline
    _set_u fish_pager_color_progress $p_pager_prog_fg --background=$p_pager_prog_bg
    _set_u fish_pager_color_completion $p_pager_compl
    _set_u fish_pager_color_description $p_pager_desc --style=italic
    _set_u fish_pager_color_selected_background --background=$p_pager_sel_bg

    # FZF and Hydro prompt colors
    _set_ux FZF_DEFAULT_OPTS "$fzf_opts"
    _set_u hydro_color_pwd $h_pwd
    _set_u hydro_color_git $h_git
    _set_u hydro_color_error $h_error
    _set_u hydro_color_prompt $h_prompt
    _set_u hydro_color_duration $h_duration

    # Lazygit theme
    if test -f "$_dotfiles/lazygit/config-base.yml"
        mkdir -p "$lazygit_dir"
        cat "$_dotfiles/lazygit/config-base.yml" "$lazygit_theme" >"$lazygit_dir/config.yml"
    end

    # Lazydocker theme
    if test -f "$_dotfiles/lazydocker/config-base.yml"
        set -l lazydocker_dir "$HOME/Library/Application Support/lazydocker"
        test (uname) = Linux; and set lazydocker_dir "$HOME/.config/lazydocker"
        mkdir -p "$lazydocker_dir"
        cat "$_dotfiles/lazydocker/config-base.yml" "$lazydocker_theme" >"$lazydocker_dir/config.yml"
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
    set -l btop_themes "$_dotfiles/btop/themes/"*.theme
    if set -q btop_themes[1]
        cp $btop_themes "$HOME/.config/btop/themes/" 2>/dev/null
    end
    if test -f "$_dotfiles/btop/btop-base.conf"
        set -l _btop_tmp (mktemp)
        if grep -q "^color_theme =" "$_dotfiles/btop/btop-base.conf"
            string replace -r -- '^color_theme = .*' "color_theme = \"$btop_theme\"" <"$_dotfiles/btop/btop-base.conf" >"$_btop_tmp"
        else
            cat "$_dotfiles/btop/btop-base.conf" >"$_btop_tmp"
            echo "color_theme = \"$btop_theme\"" >>"$_btop_tmp"
        end
        mv "$_btop_tmp" "$HOME/.config/btop/btop.conf"
    end

    # K9s skin
    set -l k9s_dir "$HOME/Library/Application Support/k9s"
    test (uname) = Linux; and set k9s_dir "$HOME/.config/k9s"
    mkdir -p "$k9s_dir/skins"
    set -l k9s_skins "$_dotfiles/k9s/skins/"*.yaml
    if set -q k9s_skins[1]
        cp $k9s_skins "$k9s_dir/skins/" 2>/dev/null
    end
    if test -f "$_dotfiles/k9s/config-base.yaml"
        set -l _k9s_tmp (mktemp)
        if grep -q "skin:" "$_dotfiles/k9s/config-base.yaml"
            string replace -r -- 'skin: .*' "skin: $k9s_skin" <"$_dotfiles/k9s/config-base.yaml" >"$_k9s_tmp"
        else
            awk -v skin="$k9s_skin" '
                /^  ui:/ { print; print "    skin: " skin; injected=1; next }
                { print }
                END { if (!injected) { print "  ui:"; print "    skin: " skin } }
            ' "$_dotfiles/k9s/config-base.yaml" >"$_k9s_tmp"
        end
        mv "$_k9s_tmp" "$k9s_dir/config.yaml"
    end

    # pgcli theme
    if test -f "$_dotfiles/pgcli/config-base"
        mkdir -p "$HOME/.config/pgcli"
        cat "$_dotfiles/pgcli/config-base" "$pgcli_theme" >"$HOME/.config/pgcli/config"
    end

    # tealdeer theme
    if test -f "$_dotfiles/tealdeer/config-base.toml"
        mkdir -p "$HOME/.config/tealdeer"
        cat "$_dotfiles/tealdeer/config-base.toml" "$tealdeer_theme" >"$HOME/.config/tealdeer/config.toml"
    end

    # Zellij theme (live hot-swap — Zellij reloads config.kdl automatically on macOS,
    # but on Linux cat > truncates and might panic the watcher. We rely on action broadcast below).
    if test -f "$_dotfiles/zellij/config-base.kdl"
        mkdir -p "$HOME/.config/zellij"
        cp -r "$_dotfiles/zellij/themes" "$HOME/.config/zellij/" 2>/dev/null
        set -l _zj_cfg "$HOME/.config/zellij/config.kdl"
        set -l _zj_tmp (mktemp)
        string replace -r -- '^theme .*' "theme \"$zellij_theme\"" <"$_dotfiles/zellij/config-base.kdl" >"$_zj_tmp"
        mv "$_zj_tmp" "$_zj_cfg"
    end

    if command -q zellij
        set -l zj_action set-dark-theme
        if test "$theme" = light
            set zj_action set-light-theme
        end
        for session in (zellij list-sessions -n 2>/dev/null | awk '{print $1}')
            zellij --session "$session" action "$zj_action" 2>/dev/null
        end
    end

    set -U _switch_theme_active "$theme"
    functions --erase _set_u _set_ux
end
