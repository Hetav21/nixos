{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  pnpm_9,
  pkg-config,
  openssl,
  runCommand,
  jq,
  playwright-driver,
}: let
  pname = "agent-browser";
  version = "0.0.1-unstable-2025-02-08";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    rev = "4d8097a56fe9990eb2e5cecb6d167eb6897eda06";
    sha256 = "1z3xi8my2qf1sx68wx89i2lnhg9cwz34m0rlz0kbiss8ikk6z5p6";
  };

  # Patch source to match system Playwright version (1.56.1)
  # This avoids binary incompatibility between agent-browser (1.57.0) and Nix (1.56.1)
  patchedSrc =
    runCommand "${pname}-src" {
      inherit src;
      nativeBuildInputs = [jq];
    } ''
      cp -r $src $out
      chmod -R +w $out

      # Replace 1.57.0 with 1.56.1 in package.json
      # sed -i 's/"playwright-core": "\^1.57.0"/"playwright-core": "1.56.1"/g' $out/package.json
      # sed -i 's/"playwright": "\^1.57.0"/"playwright": "1.56.1"/g' $out/package.json
      sed -i 's/1.57.0/1.56.1/g' $out/package.json

      # Update lockfile manually to avoid pnpm issues with missing lockfile
      # This is a hack because pnpmDeps requires a lockfile to fetch deps
      sed -i 's/1.57.0/1.56.1/g' $out/pnpm-lock.yaml

      # Just fix the pnpmDeps hash - we don't need to patch integrity if we update the hash below!
      # Wait, pnpm itself checks integrity.
      # The previous error "Got unexpected checksum" was from pnpm.
      # So we DO need to patch integrity in the lockfile.

      # The error "ParserError" from yq means we broke the yaml syntax with sed.
      # The sed replacement strings contained `|` but `g` was used? No, I used `|` as delimiter.
      # But wait, the integrity string contains `/` and `+` and `=`.
      # `|` is safe.
      # Maybe the newlines in the file or indentation?

      # Let's try to be safer and replace ONLY the specific line that matches.
      # But first, let's revert the broken sed commands and use a simpler one.

      # We know the specific string we want to replace.
      # Old: integrity: sha512-agTcKlMw/mjBWOnD6kFZttAAGHgi/Nw0CZ2o6JqWSbMlI219lAFLZZCyqByTsvVAJq5XA5H8cA6PrvBRpBWEuQ==
      # New: integrity: sha512-hutraynyn31F+Bifme+Ps9Vq59hKuUCz7H1kDOcBs+2oGguKkWTU50bBWrtz34OUWmIwpBTWDxaRPXrIXkgvmQ==

      sed -i "s|integrity: sha512-agTcKlMw/mjBWOnD6kFZttAAGHgi/Nw0CZ2o6JqWSbMlI219lAFLZZCyqByTsvVAJq5XA5H8cA6PrvBRpBWEuQ==|integrity: sha512-hutraynyn31F+Bifme+Ps9Vq59hKuUCz7H1kDOcBs+2oGguKkWTU50bBWrtz34OUWmIwpBTWDxaRPXrIXkgvmQ==|" $out/pnpm-lock.yaml
      sed -i "s|integrity: sha512-ilYQj1s8sr2ppEJ2YVadYBN0Mb3mdo9J0wQ+UuDhzYqURwSoW4n1Xs5vs7ORwgDGmyEh33tRMeS8KhdkMoLXQw==|integrity: sha512-aFi5B0WovBHTEvpM3DzXTUaeN6eN0qWnTkKx4NQaH4Wvcmc153PdaY2UBdSYKaGYw+UyWXSVyxDUg5DoPEttjw==|" $out/pnpm-lock.yaml
    '';

  # Node.js dependencies
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version;
    src = patchedSrc;
    hash = "sha256-8UhU4c6ZiDkYPxJxQ84qvi7eWQ40Wb2RS+UOFbeH6mw=";
    fetcherVersion = 3;
    # pnpmLockYaml = null;
  };
in
  rustPlatform.buildRustPackage {
    inherit pname version pnpmDeps;
    src = patchedSrc;

    # Rust build configuration
    # buildAndTestSubdir = "cli";
    sourceRoot = "agent-browser-src/cli";
    cargoHash = "sha256-aCyZNyos5DQhp+9qvLsws+aMDUtxbOTa0xolyxS8tU4=";

    nativeBuildInputs = [
      makeWrapper
      pkg-config
      nodejs
      pnpm_9.configHook
    ];

    buildInputs = [
      openssl
    ];

    # Configure pnpm
    # inherit pnpmDeps;

    postUnpack = ''
      # Verify directory structure
      ls -R
      chmod -R u+w .
    '';

    preBuild = ''
      # Build Node.js components
      pushd ..
      pnpm install --no-frozen-lockfile
      pnpm run build
      popd
    '';

    doCheck = false;

    postInstall = ''
      mkdir -p $out/lib/agent-browser
      cp -r ../dist $out/lib/agent-browser/
      cp -r ../node_modules $out/lib/agent-browser/

      wrapProgram $out/bin/agent-browser \
        --set AGENT_BROWSER_HOME "$out/lib/agent-browser" \
        --set PLAYWRIGHT_BROWSERS_PATH "${playwright-driver.browsers}" \
        --set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD "1" \
        --prefix PATH : "${lib.makeBinPath [nodejs playwright-driver]}"
    '';

    meta = with lib; {
      description = "Agent Browser - Browser automation agent";
      homepage = "https://github.com/vercel-labs/agent-browser";
      license = licenses.mit;
      mainProgram = "agent-browser";
      maintainers = [];
    };
  }
