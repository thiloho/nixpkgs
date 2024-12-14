{
  lib,
  stdenv,
  buildNpmPackage,
  importNpmLock,
  symlinkJoin,
  fetchFromGitHub,
}:

let
  src = fetchFromGitHub {
    owner = "archtika";
    repo = "archtika";
    rev = "v1.0.1";
    hash = "sha256-+zZ2v2kYpJ12bJYURt4Ax5Mt3zgr+WQjnxLbAx0DKY0=";
  };

  web = buildNpmPackage {
    name = "web-app";
    src = "${src}/web-app";
    npmDepsHash = "sha256-RTyo7K/Hr1hBGtcBKynrziUInl91JqZl84NkJg16ufA=";
    npmFlags = [ "--legacy-peer-deps" ];
    installPhase = ''
      mkdir -p $out/web-app
      cp package.json $out/web-app
      cp -r node_modules $out/web-app
      cp -r build/* $out/web-app
      cp -r template-styles $out/web-app
    '';
  };

  api = stdenv.mkDerivation {
    name = "api";
    src = "${src}/rest-api";
    installPhase = ''
      mkdir -p $out/rest-api/db/migrations
      cp -r db/migrations/* $out/rest-api/db/migrations
    '';
  };
in
symlinkJoin {
  pname = "archtika";
  version = "1.0.1";

  paths = [
    web
    api
  ];

  meta = with lib; {
    description = "A modern, performant and lightweight CMS";
    homepage = "https://archtika.com";
    license = licenses.gpl3;
    maintainers = with maintainers; [ thiloho ];
    platforms = platforms.unix;
  };
}
