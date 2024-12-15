{
  lib,
  stdenv,
  buildNpmPackage,
  importNpmLock,
  symlinkJoin,
  fetchFromGitHub,
}:

let
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "archtika";
    repo = "archtika";
    rev = "v${version}";
    hash = "sha256-IDSh1YeQiVRdfY3pUM1RDXpZDT/7vXDx4EYH8gEmmj4=";
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
  version = version;

  paths = [
    web
    api
  ];

  meta = {
    description = "A modern, performant and lightweight CMS";
    homepage = "https://archtika.com";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.thiloho ];
    platforms = lib.platforms.unix;
  };
}
