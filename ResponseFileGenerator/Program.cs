using AngleSharp.Dom;
using AngleSharp.Xml.Parser;

if (args.Length != 2)
{
    Console.Error.WriteLine("Usage: ResponseFileGenerator <source.xml> <output-directory>");
    return 1;
}

using FileStream input = File.OpenRead(args[0]);
IDocument document = new XmlParser().ParseDocument(input);
IElement root = document.DocumentElement
    ?? throw new InvalidDataException("The XML document has no root element.");
if (root.LocalName != "bindings")
{
    throw new InvalidDataException("The XML document root must be <bindings>.");
}

HashSet<string> declarations = new(StringComparer.Ordinal);
HashSet<string> functions = new(StringComparer.Ordinal);
CollectDeclarations(root, null);

Directory.CreateDirectory(args[1]);
WriteResponseFile("windows-attributes.rsp", "WindowsApi", "SupportedOSPlatform(\"windows\")");
WriteResponseFile("unix-attributes.rsp", "UnixApi", "SupportedOSPlatform(\"macos\")", "SupportedOSPlatform(\"linux\")");
File.WriteAllLines(
    Path.Combine(args[1], "usings.rsp"),
    functions.Order(StringComparer.Ordinal).Select(name => $"{name}=System.Runtime.Versioning"));
return 0;

void CollectDeclarations(IElement element, string? declaringType)
{
    foreach (IElement child in element.Children)
    {
        bool isType = child.LocalName is "class" or "enumeration" or "struct";
        bool isFunction = child.LocalName == "function";
        if (isType || isFunction)
        {
            string name = child.GetAttribute("name")
                ?? throw new InvalidDataException($"A <{child.LocalName}> element has no name.");
            if (string.IsNullOrWhiteSpace(name))
            {
                throw new InvalidDataException($"A <{child.LocalName}> element has an empty name.");
            }

            if (isType && child.LocalName == "class" && declaringType is null && name == "PlaceholderClassName")
            {
                CollectDeclarations(child, null);
                continue;
            }

            string qualifiedName = declaringType is null ? name : $"{declaringType}::{name}";
            declarations.Add(qualifiedName);
            if (isType)
            {
                CollectDeclarations(child, qualifiedName);
            }
            else
            {
                functions.Add(qualifiedName);
            }
        }
        else
        {
            CollectDeclarations(child, declaringType);
        }
    }
}

void WriteResponseFile(string fileName, string commonValue, params string[] functionValues)
{
    File.WriteAllLines(
        Path.Combine(args[1], fileName),
        declarations.Order(StringComparer.Ordinal).SelectMany(name =>
            functions.Contains(name)
                ? new[] { $"{name}={commonValue}" }.Concat(functionValues.Select(value => $"{name}={value}"))
                : new[] { $"{name}={commonValue}" }));
}
