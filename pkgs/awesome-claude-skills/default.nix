{
  lib,
  stdenvNoCC,
  awesome-claude-skills-src,
}:
stdenvNoCC.mkDerivation {
  name = "awesome-claude-skills";
  src = awesome-claude-skills-src;
  installPhase = "mkdir -p $out; cp -r $src/. $out/";
}
