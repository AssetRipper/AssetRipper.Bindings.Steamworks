using System;
using System.Diagnostics.CodeAnalysis;
using System.Diagnostics;

namespace AssetRipper.Bindings.Steamworks;

internal static class ThrowHelper
{
    [DoesNotReturn]
    [DebuggerHidden]
    [StackTraceHidden]
    public static void ThrowPlatformNotSupportedException()
    {
        throw new PlatformNotSupportedException();
    }
}