export-env {
    $env.config.color_config = {
        separator: "#26233a"
        leading_trailing_space_bg: "#908caa"
        header: "green"
        date: "yellow"
        filesize: "cyan"
        row_index: "bright black"
        bool: "red"
        int: "green"
        duration: "yellow"
        range: "blue"
        float: "blue"
        string: "yellow"
        nothing: "red"
        binary: "yellow"
        cellpath: "blue"
        hints: dark_gray
        
        shape_garbage: { fg: "#26233a" bg: "red" }
        shape_bool: "bright green"
        shape_int: { fg: "green" attr: b }
        shape_float: { fg: "blue" attr: b }
        shape_range: { fg: "cyan" attr: b }
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
    }
}
