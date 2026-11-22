using System;
using System.Runtime.Versioning;

namespace AssetRipper.Bindings.Steamworks;

public static class OperatingSystemExtensions
{
    extension(OperatingSystem)
    {
        [SupportedOSPlatformGuard("linux")]
        [SupportedOSPlatformGuard("macos")]
        public static bool IsUnix() => OperatingSystem.IsLinux() || OperatingSystem.IsMacOS();
    }
}
