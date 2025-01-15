# This is Raylib but build statically with make.

{ stdenv
, lib
, fetchFromGitHub
, mesa
, libGLU
, glfw
, libX11
, libXi
, libXcursor
, libXrandr
, libXinerama
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsa-lib
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
, raylib-games
, darwin
, autoPatchelfHook
, gnumake
}:
let
  inherit (darwin.apple_sdk.frameworks) Carbon Cocoa OpenGL;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "raylib-static";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = "raylib";
    rev = finalAttrs.version;
    hash = "sha256-gEstNs3huQ1uikVXOW4uoYnIDr5l8O9jgZRTX1mkRww=";
  };

  nativeBuildInputs = [ ] ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook;

  buildInputs = [ glfw ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ mesa libXi libXcursor libXrandr libXinerama ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Carbon Cocoa ]
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseSupport libpulseaudio;

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libGLU libX11 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ OpenGL ];

  buildPhase = ''
    cd src
    make PLATFORM=PLATFORM_DESKTOP
  '';

  installPhase = ''
    mkdir -p $out
    cp libraylib.a $out/
  '';

  passthru.tests = { inherit raylib-games; };

  # From nixpkgs raylib:
  # fix libasound.so/libpulse.so not being found
  appendRunpaths = lib.optionals stdenv.hostPlatform.isLinux [
    (lib.makeLibraryPath (lib.optional alsaSupport alsa-lib ++ lib.optional pulseSupport libpulseaudio))
  ];

  meta = with lib; {
    description = "Simple and easy-to-use library to enjoy videogames programming (static).";
    homepage = "https://www.raylib.com/";
    license = licenses.zlib;
    maintainers = [ ];
    platforms = platforms.all;
    changelog = "https://github.com/raysan5/raylib/blob/${finalAttrs.version}/CHANGELOG";
  };
})
