# Nushell Color Configuration
export-env {
    $env.config = ($env.config | default {} | merge {
        color_config: {
            # Primitive colors
            string: 'yellow'
            number: 'purple'
            binary: 'purple'
            bool: 'purple'
            date: 'cyan'
            range: 'purple'
            float: 'purple'
            filesize: 'cyan'
            duration: 'purple'
            special: 'yellow'

            # Shape colors
            shape_and: 'green'
            shape_binary: 'green'
            shape_block: 'cyan'
            shape_bool: 'light_green'
            shape_closure: 'green'
            shape_custom: 'green'
            shape_datetime: 'cyan'
            shape_directory: 'cyan'
            shape_external: 'cyan'
            shape_externalarg: 'green'
            shape_filepath: 'cyan'
            shape_flag: 'cyan'
            shape_float: 'purple'
            shape_garbage: 'red'
            shape_globpattern: 'cyan'
            shape_int: 'purple'
            shape_internalcall: 'cyan'
            shape_keyword: 'magenta'
            shape_list: 'cyan'
            shape_literal: 'green'
            shape_match_pattern: 'yellow'
            shape_nothing: 'light_green'
            shape_operator: 'yellow'
            shape_or: 'green'
            shape_pipe: 'green'
            shape_range: 'purple'
            shape_record: 'cyan'
            shape_redirection: 'cyan'
            shape_signature: 'green'
            shape_string: 'green'
            shape_string_interpolation: 'cyan'
            shape_table: 'cyan'
            shape_variable: 'purple'

            # Separator colors
            separator: 'green'

            # Bordercolor
            border_color: 'green'
        }
    })
}
