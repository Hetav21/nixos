# Nushell Color Configuration
export-env {
    $env.config.color = {
        # Autosuggestion color
        autosuggestion: '#26233a'

        # Command color
        command: 'green'

        # Comment color
        comment: '#26233a'

        # Current working directory color
        cwd: 'green'

        # Root working directory color
        cwd_root: 'red'

        # End color (likely for command endings)
        end: 'bright black'

        # Error color
        error: 'red'

        # Escape sequence color
        escape: 'yellow'

        # Current history color
        history_current: 'bold'

        # Host color
        host: 'default'

        # Remote host color
        host_remote: 'yellow'

        # Match color (for selections/matches)
        match: { bg: 'bright blue' }

        # Normal text color
        normal: 'default'

        # Operator color
        operator: 'blue'

        # Parameter color
        param: '#908caa'

        # Quote color
        quote: 'yellow'

        # Redirection color
        redirection: 'cyan'

        # Search match color
        search_match: { 
            fg: 'bright yellow'
            bg: '#26233a'
        }

        # Selection color
        selection: {
            fg: 'white'
            bg: '#26233a'
            attr: 'bold'
        }

        # Status color
        status: 'red'

        # User color
        user: 'bright green'

        # Valid path color
        valid_path: 'underline'
    }

    # Pager colors
    $env.config.color.pager = {
        # Completion color
        completion: 'default'

        # Description color
        description: {
            fg: 'yellow'
            attr: 'dim'
        }

        # Prefix color
        prefix: {
            fg: 'white'
            attr: 'bold'
        }

        # Progress color
        progress: {
            fg: 'bright white'
            bg: 'cyan'
        }

        # Selected background color
        selected_background: 'reverse'
    }
}
