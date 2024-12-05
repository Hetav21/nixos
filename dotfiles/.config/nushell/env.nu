let starship_cache = "/home/hetav/.cache/starship"
if not ($starship_cache | path exists) {
  mkdir $starship_cache
}
/etc/profiles/per-user/hetav/bin/starship init nu | save --force /home/hetav/.cache/starship/init.nu

let carapace_cache = "/home/hetav/.cache/carapace"
if not ($carapace_cache | path exists) {
  mkdir $carapace_cache
}
/nix/store/n1anlj6fvjss5ak0r0030pf7sj7rg53f-carapace-1.0.7/bin/carapace _carapace nushell | save -f $"($carapace_cache)/init.nu"

load-env {}
