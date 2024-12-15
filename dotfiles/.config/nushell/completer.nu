export-env {
# Nushell Configuration

# Carapace completer
let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans 
    | from json 
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

# Zoxide completer
let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

# Fish completer
let fish_completer = {|spans|
    fish --command complete "--do-complete=($spans)" 
    | from tsv --flexible --noheaders --no-infer 
    | rename value description
}

# External completer with smart routing
let external_completer = {|spans|
    let expanded_alias = scope aliases 
    | where name == $spans.0 
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans 
        | skip 1 
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        nu => $fish_completer
        asdf => $fish_completer
        __zoxide_z | __zoxide_zi => $zoxide_completer
        * => $carapace_completer
    } | do $in $spans
}

# Comprehensive Nushell Configuration
$env.config = {
    show_banner: false,
    completions: {
        case_sensitive: false, # case-sensitive completions
        quick: true,    # set to false to prevent auto-selecting completions
        partial: true,    # set to false to prevent partial filling of the prompt
        algorithm: "fuzzy",    # prefix or fuzzy
        external: {
            # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true,
            # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100,
            completer: $external_completer # check 'carapace_completer'
        }
    }
}
}
