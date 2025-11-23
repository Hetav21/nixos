{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule {
  pname = "pokego";
  version = "v0.5.2";
  src = fetchFromGitHub {
    owner = "rubiin";
    repo = "pokego";
    rev = "v0.5.2";
    hash = "sha256-GBKQ9YV98znhTP9QsvAAyva8dNohFS8dbQ4FAG5IDig=";
  };

  vendorHash = "sha256-7SoKHH+tDJKhUQDoVwAzVZXoPuKNJEHDEyQ77BPEDQ0=";
  env.CGO_ENABLED = 0;
  flags = ["-trimpath"];
  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  meta = with lib; {
    description = "Command-line tool that lets you display Pokémon sprites in color directly in your terminal.";
    homepage = "https://github.com/rubiin/pokego";
    mainProgram = "pokego";
    license = licenses.gpl3;
    maintainers = with maintainers; [rubiin];
  };
}
