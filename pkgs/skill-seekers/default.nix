{
  lib,
  python3,
  fetchFromGitHub,
  git,
  tesseract,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "skill-seekers";
  version = "2.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yusufkaraaslan";
    repo = "Skill_Seekers";
    rev = "v${version}";
    sha256 = "1j65siii1rbjsx8spljjxi3zsly2qb24nxgr2mg70k7myr4vxm5n";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "mcp>=1.25,<2" "mcp" \
      --replace-fail "httpx-sse>=0.4.3" "httpx-sse" \
      --replace-fail "uvicorn>=0.38.0" "uvicorn" \
      --replace-fail "starlette>=0.48.0" "starlette" \
      --replace-fail "sse-starlette>=3.0.2" "sse-starlette" \
      --replace-fail "anthropic>=0.76.0" "anthropic>=0.75.0" \
      --replace-fail "pydantic>=2.12.3" "pydantic>=2.11.0" \
      --replace-fail "pydantic-settings>=2.11.0" "pydantic-settings>=2.10.0" \
      --replace-fail "jsonschema>=4.25.1" "jsonschema>=4.25.0" \
      --replace-fail "click>=8.3.0" "click>=8.2.0"

    # Add entry point for MCP server
    sed -i '/skill-seekers-setup = "skill_seekers.cli.setup_wizard:main"/a skill-seekers-mcp = "skill_seekers.mcp.server_fastmcp:main"' pyproject.toml
  '';

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    requests
    beautifulsoup4
    pygithub
    gitpython
    httpx
    anthropic
    pymupdf
    pillow
    pytesseract
    pydantic
    pydantic-settings
    python-dotenv
    jsonschema
    click
    pygments
    pathspec
    networkx
    # MCP Dependencies
    mcp
    httpx-sse
    uvicorn
    starlette
    sse-starlette
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-asyncio
    pytest-cov
  ];

  # Tests require network access and API keys
  doCheck = false;

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [git tesseract]}"
  ];

  meta = with lib; {
    description = "Convert documentation websites, GitHub repositories, and PDFs into Claude AI skills";
    homepage = "https://skillseekersweb.com/";
    license = licenses.mit;
    mainProgram = "skill-seekers";
    maintainers = [];
  };
}
