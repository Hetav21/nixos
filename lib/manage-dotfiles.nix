# Dotfile / Config Processing Helpers
{lib, ...}: rec {
  # --- Evaluation-Time Template Substitution (Attrsets & JSON) ---
  mkSubstitute = replacements: let
    keys = builtins.attrNames replacements;
    vals = builtins.attrValues replacements;
    substituteStr = s:
      if builtins.isString s
      then builtins.replaceStrings keys vals s
      else s;
    process = v:
      if builtins.isAttrs v
      then lib.mapAttrs' (name: value: lib.nameValuePair (substituteStr name) (process value)) v
      else if builtins.isList v
      then map process v
      else substituteStr v;
  in
    process;

  # --- Build-Time Template Substitution (Text Files) ---
  mkProcessFile = pkgs: replacements: file:
    pkgs.replaceVars file replacements;
}
