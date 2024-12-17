{ lib
, stdenv
, fetchFromGitHub
, libX11
, libXft
, freetype
, cairo
, farbfeld
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "sentPDF";
  version = "unstable-2024-06-27";

  src = fetchFromGitHub {
    owner = "gboncoffee";
    repo = "sent-pdf";
    rev = "bafe3607358fc1f6206f1608a2969f3e829033b8";
    hash = "sha256-tlK9RdtqVTSK33+rgedoQQI+Cz0zhob8raZ6qAJnYNk=";
  };

  meta = with lib; {
    description = "Sent(1) with PDF patch";
    homepage = "https://github.com/gboncoffee/sent-pdf";
    license = licenses.isc;
    mainProgram = "sent";
    platforms = platforms.all;
  };

  prePatch = ''
    sed -i "s@/usr/local@$out@" config.mk
  '';

  nativeBuildInputs = [
    pkg-config
  ] ++ buildInputs;
  buildInputs = [
    libX11
    libXft
    freetype
    cairo
    farbfeld
  ];
}
