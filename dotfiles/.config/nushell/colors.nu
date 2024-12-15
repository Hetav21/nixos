export-env {
    $env.config.color_config = {
        # Base colors (matching fish color definitions)
        autosuggestion: "#26233a"
        separator: "#26233a"
        
        # Primitive and shape colors
        string: "yellow"
        int: "green"
        float: "blue"
        bool: "red"
        nothing: "red"
        binary: "yellow"
        date: "yellow"
        range: "blue"
        duration: "red"
        filesize: "cyan"
        cellpath: "blue"

        # Complex color configurations
        hints: dark_gray
        header: "green"
        row_index: "bright black"

        # Specific shape and element colors
        shape_garbage: { fg: "#524f67" bg: "red" }
        shape_bool: "#c4a7e7"
        shape_int: { fg: "green" attr: b }
        shape_float: { fg: "blue" attr: b }
        shape_range: { fg: "blue" attr: b }
        shape_internalcall: { fg: "bright black" attr: b }
        shape_external: "cyan"
        shape_externalarg: { fg: "green" attr: b }
        shape_literal: "#908caa"
        shape_operator: "blue"
        shape_signature: { fg: "green" attr: b }
        shape_string: "green"
        shape_filepath: "#908caa"
        shape_globpattern: { fg: "#908caa" attr: b }
        shape_variable: "bright green"
        shape_flag: { fg: "cyan" attr: b }
        shape_custom: { attr: b }

        # Special colors matching fish configuration
        command: "green"
        comment: "#26233a"
        cwd: "green"
        cwd_root: "red"
        end: "bright black"
        error: "red"
        escape: "yellow"
        host: "default"
        host_remote: "yellow"
        match: { bg: "bright blue" }
        normal: "default"
        operator: "blue"
        param: "#908caa"
        quote: "yellow"
        redirection: "cyan"
        
        # Search and selection colors
        search_match: { 
            fg: "bright yellow"
            bg: "#26233a"
        }
        selection: {
            fg: "white"
            bg: "#26233a"
            attr: "bold"
        }
        
        # Status and user colors
        status: "red"
        user: "bright green"
        valid_path: { attr: "underline" }

        # Pager colors (additional configurations)
        leading_trailing_space_bg: "#908caa"
        pager: {
            completion: "default"
            description: {
                fg: "yellow"
                attr: "dim"
            }
            prefix: {
                fg: "white"
                attr: "bold"
            }
            progress: {
                fg: "bright white"
                bg: "cyan"
            }
            selected_background: "reverse"
        }
    }
}
