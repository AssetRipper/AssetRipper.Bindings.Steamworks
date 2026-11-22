# Response File Generator

## Data to collect

We use AngleSharp to parse and extract useful data from the generated XML.

### Types

Types have the following XML tags:

* `class`
* `enumeration`
* `struct`

We extract their `name` attribute. If this XML element is the child of another type element, we record the parent's `name` as the declaring type.
The top-level `PlaceholderClassName` class represents free functions and is not included.

### Functions

Functions have the `function` XML tag. We extract their `name` attribute and record the parent's `name` as the declaring type, except for free functions in `PlaceholderClassName`, which are unqualified.

## Output

### Attribute Response File

We produce `Scripts\windows-attributes.rsp` and `Scripts\unix-attributes.rsp`.

For every name we've collected:

* In `Scripts\windows-attributes.rsp`, we append a new line `{name}=WindowsApi`.
* In `Scripts\unix-attributes.rsp`, we append a new line `{name}=UnixApi`.

For each function, also add `SupportedOSPlatform("windows")` on Windows and
both `SupportedOSPlatform("macos")` and `SupportedOSPlatform("linux")` on Unix.

### Usings Response File

We produce `Scripts\usings.rsp`. For each function, add `{name}=System.Runtime.Versioning`.
The shared `AssetRipper.Bindings.Steamworks.Attributes` namespace is imported globally.

## Arguments

The program takes two arguments: the source xml file and the output directory for the response files.

Run it with:

```sh
dotnet run --project ResponseFileGenerator -- output.xml Scripts
```

Nested declarations and functions use `::`-separated declaring type names. Duplicate
names are emitted once per value, in ordinal order. The output directory is created if needed.
