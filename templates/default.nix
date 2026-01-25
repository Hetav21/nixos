{
  default = {
    path = ./empty;
    description = "Empty development environment";
  };
  bun = {
    path = ./bun;
    description = "Bun development environment";
  };
  empty = {
    path = ./empty;
    description = "Empty dev template that you can customize at will";
  };
  go = {
    path = ./go;
    description = "Golang development environment";
  };
  jupyter = {
    path = ./jupyter;
    description = "Jupyter development environment";
  };
  nix = {
    path = ./nix;
    description = "Nix development environment";
  };
  node = {
    path = ./node;
    description = "Node.js development environment";
  };
  python = {
    path = ./python;
    description = "Python development environment";
  };
  shell = {
    path = ./shell;
    description = "Shell script development environment";
  };
  uv = {
    path = ./uv;
    description = "Python development environment with uv package manager";
  };
  playwright = {
    path = ./playwright;
    description = "Playwright testing environment with Nix-native browsers";
  };
}
