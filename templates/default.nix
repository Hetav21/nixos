{
  # --- Base Templates ---
  default = {
    path = ./empty;
    description = "Empty development environment";
  };
  empty = {
    path = ./empty;
    description = "Empty development environment";
  };

  # --- Frontend Templates ---
  frontend-bun = {
    path = ./frontend-bun;
    description = "Frontend Bun development environment (Playwright)";
  };
  frontend-node = {
    path = ./frontend-node;
    description = "Frontend Node.js development environment (Playwright)";
  };

  # --- Backend Templates ---
  backend-bun = {
    path = ./backend-bun;
    description = "Backend Bun development environment";
  };
  backend-node = {
    path = ./backend-node;
    description = "Backend Node.js development environment";
  };
  backend-go = {
    path = ./backend-go;
    description = "Backend Golang development environment";
  };

  # --- AI & Data Templates ---
  ai-pip = {
    path = ./ai-pip;
    description = "AI Python environment (pip)";
  };
  ai-uv = {
    path = ./ai-uv;
    description = "AI Python environment (uv)";
  };
  notebook = {
    path = ./notebook;
    description = "Jupyter Notebook environment";
  };

  # --- Testing Templates ---
  browser = {
    path = ./browser;
    description = "Playwright Browser testing environment";
  };
}
