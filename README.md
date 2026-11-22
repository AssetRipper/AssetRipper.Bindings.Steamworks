# AssetRipper.Bindings.Steamworks

This is a cross-platform .NET 10 library for 64 bit architectures. It provides low-level bindings for the Steamworks API, generated with [ClangSharp](https://github.com/dotnet/clangsharp/).

## Cross-platform compatibility

Steamworks has differing behavior on Windows and Unix, particularly around struct layout (search for VALVE_CALLBACK_PACK_SMALL or VALVE_CALLBACK_PACK_LARGE). In addition, Windows uses the library name `steam_api64` and Unix uses `libsteam_api`.

To handle this, we provide two sets of bindings, each one marked with `SupportedOSPlatformAttribute` to encourage responsible use.
