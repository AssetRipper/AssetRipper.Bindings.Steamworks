using System;

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
                AllowMultiple = false, Inherited = false)]
internal sealed class WindowsApiAttribute : Attribute;
