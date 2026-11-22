# Generation

## Unix headers on Windows

From the repository root on Windows, run `.\Scripts\download-linux-headers.ps1` to download the Debian x64
headers into `Cache\linux-sysroot`. The script requires 7-Zip and `tar.exe`;
use `-Destination` to choose a different, non-existent directory.
Run `.\Scripts\generate-unix.bat` to generate bindings using the default header location.
It requires Clang on `PATH` to locate its builtin headers.
Run `.\Scripts\generate-attributes.bat` to generate shared attributes in `Attributes` and
the assembly-level runtime marshalling attribute. Run `.\Scripts\generate-transparent-structs.bat`
to generate transparent structs in `Helpers`.
