# For a 64bit + 32bit system the LD_LIBRARY_PATH must contain both the 32bit and 64bit primus
# libraries. Providing a different primusrun for each architecture will not work as expected. EG:
# Using steam under wine can involve both 32bit and 64bit process. All of which inherit the
# same LD_LIBRARY_PATH.
# Other distributions do the same.
{ stdenv
, stdenv_i686
, lib
, primusLib
, writeScriptBin
, runtimeShell
, primusLib_i686 ? null
, useNvidia ? true
, nvidia_x11 ? null
}:

let
  # We override stdenv in case we need different ABI for libGL
  primus = primusLib.override { inherit stdenv; nvidia_x11 = if useNvidia then nvidia_x11 else  null; };
  primus_i686 = primusLib_i686.override { stdenv = stdenv_i686; nvidia_x11 = if useNvidia then nvidia_x11 else null; };

  ldPath = lib.makeLibraryPath (lib.filter (x: x != null) (
    [ primus primus.glvnd ]
    ++ lib.optionals (primusLib_i686 != null) [ primus_i686 primus_i686.glvnd ]
  ));

in writeScriptBin "primusrun" ''
  #!${runtimeShell}
  export LD_LIBRARY_PATH=${ldPath}''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
  # https://bugs.launchpad.net/ubuntu/+source/bumblebee/+bug/1758243
  export __GLVND_DISALLOW_PATCHING=1
  exec "$@"
''
