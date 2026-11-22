using System;
using System.Diagnostics;

namespace AssetRipper.Bindings.Steamworks.Attributes;

[AttributeUsage(AttributeTargets.Class |
                AttributeTargets.Constructor |
                AttributeTargets.Enum |
                AttributeTargets.Event |
                AttributeTargets.Field |
                AttributeTargets.Interface |
                AttributeTargets.Method |
                AttributeTargets.Property |
                AttributeTargets.Struct,
                AllowMultiple = true, Inherited = false)]
[Conditional("DEBUG")]
internal sealed class WindowsApiAttribute : Attribute;
