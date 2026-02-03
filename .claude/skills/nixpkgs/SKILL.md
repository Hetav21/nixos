---
name: nixpkgs
description: Use when creating packages (mkDerivation), using the Nixpkgs library (lib), or writing overlays.
---

# Nixpkgs & Standard Library Reference

## Overview
Reference for the Nixpkgs standard library (`lib`) functions and package creation using `mkDerivation`.

## 1. Nixpkgs Library (`lib`)

Access via `pkgs.lib` or just `lib` if passed in arguments.

### Common Functions

| Category | Function | Usage / Example |
| :--- | :--- | :--- |
| **Lists** | `forEach` | `forEach [1 2] (x: x*2)` -> `[2 4]` |
| | `filter` | `filter (x: x>1) [1 2]` -> `[2]` |
| | `unique` | `unique [1 1 2]` -> `[1 2]` |
| | `optionals` | `optionals bool [ "a" ]` -> `["a"]` or `[]` |
| | `foldl'` | `foldl' (acc: x: acc + x) 0 [1 2 3]` -> `6` |
| **Strings** | `concatStringsSep` | `concatStringsSep "," ["a" "b"]` -> `"a,b"` |
| | `hasPrefix` | `hasPrefix "foo" "foobar"` -> `true` |
| | `removeSuffix` | `removeSuffix ".nix" "file.nix"` -> `"file"` |
| | `lowerChars` | `stringToCharacters "abc"` (Use `toLower` for case) |
| **Attrs** | `mapAttrs` | `mapAttrs (k: v: v*2) { a=1; }` -> `{ a=2; }` |
| | `recursiveUpdate` | `recursiveUpdate {a.b=1;} {a.c=2;}` -> `{a={b=1;c=2;}}` |
| | `optionalAttrs` | `optionalAttrs bool { a=1; }` -> `{ a=1; }` or `{}` |
| | `attrNames` | `attrNames { a=1; }` -> `["a"]` |
| **Debug** | `trace` | `trace "Output this" value` -> Prints + returns value |
| | `traceVal` | `traceVal x` -> Prints x and returns x |

## 2. Package Creation (`mkDerivation`)

Template for packaging software with `stdenv`.

```nix
{ lib, stdenv, fetchFromGitHub, openssl, pkg-config, cmake }:

stdenv.mkDerivation rec {
  pname = "my-package";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "user";
    repo = "repo";
    rev = "v${version}";
    hash = "sha256-PLACEHOLDER"; # Use lib.fakeSha256 first to get hash
  };

  # Build-time tools (compilers, linters, setup hooks)
  # run on build machine
  nativeBuildInputs = [ 
    pkg-config 
    cmake 
  ];

  # Runtime dependencies (libraries, linked binaries)
  # run on host machine
  buildInputs = [ 
    openssl 
  ];

  # Common phases (override only if needed)
  # configurePhase = ''./configure --prefix=$out'';
  # buildPhase = ''make'';
  
  # Custom install phase example
  installPhase = ''
    runHook preInstall
    
    mkdir -p $out/bin
    cp bin/my-tool $out/bin/
    
    runHook postInstall
  '';

  meta = with lib; {
    description = "A short description";
    homepage = "https://github.com/user/repo";
    license = licenses.mit;
    maintainers = with maintainers; [ maintainer-name ];
    platforms = platforms.linux;
  };
}
```

### Dependency Types Reference

| Attribute | Use For | Examples |
| :--- | :--- | :--- |
| `nativeBuildInputs` | Tools needed *during* build (host platform) | `pkg-config`, `cmake`, `ninja`, `git` |
| `buildInputs` | Libraries/tools linked *at runtime* (target platform) | `openssl`, `gtk3`, `glibc`, `python3` |
| `propagatedBuildInputs` | Dependencies needed by dependents | Python libs, Rust libs |

## 3. Overlays

How to modify or extend nixpkgs.

```nix
final: prev: {
  # Add new package
  my-package = final.callPackage ./pkgs/my-package {};

  # Override existing package
  hello = prev.hello.overrideAttrs (old: {
    src = ...;
    patches = (old.patches or []) ++ [ ./fix.patch ];
  });
}
```
