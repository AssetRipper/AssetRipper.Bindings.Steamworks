param(
    [string] $Destination = (Join-Path $PSScriptRoot 'Cache\linux-sysroot'),
    [string] $SevenZip = '7z'
)

$ErrorActionPreference = 'Stop'

if ($SevenZip -eq '7z' -and -not (Get-Command $SevenZip -ErrorAction SilentlyContinue)) {
    $SevenZip = Join-Path ${env:ProgramFiles} '7-Zip\7z.exe'
}
if (-not (Get-Command $SevenZip -ErrorAction SilentlyContinue)) {
    throw '7-Zip is required. Install it or pass its executable path using -SevenZip.'
}
if (-not (Get-Command tar.exe -ErrorAction SilentlyContinue)) {
    throw 'tar.exe is required.'
}

$Destination = [System.IO.Path]::GetFullPath($Destination)
if (Test-Path -LiteralPath $Destination) {
    throw "Destination already exists: $Destination"
}
$parent = [System.IO.Path]::GetDirectoryName($Destination)
New-Item -ItemType Directory -Force -Path $parent | Out-Null
$work = Join-Path $parent ('.linux-headers-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $work | Out-Null

$packages = @(
    @{
        Url = 'https://deb.debian.org/debian/pool/main/g/glibc/libc6-dev_2.36-9+deb12u14_amd64.deb'
        Hash = '0218FC2BEFCD784C1B0C6292C0A137CE89FAD054EFAA579AD083BEE0F2C01AAE'
    },
    @{
        Url = 'https://deb.debian.org/debian/pool/main/l/linux/linux-libc-dev_6.1.176-1_amd64.deb'
        Hash = '8BB258735B9DFFBB111DA778EBDD024750878E435FFD9DFCADCB6762EDE6B4CF'
    }
)

try {
    $sysroot = Join-Path $work 'sysroot'
    New-Item -ItemType Directory -Path $sysroot | Out-Null
    foreach ($package in $packages) {
        $deb = Join-Path $work 'package.deb'
        $xz = Join-Path $work 'data.tar.xz'
        $tar = Join-Path $work 'data.tar'
        Write-Host "Downloading $($package.Url)"
        Invoke-WebRequest -Uri $package.Url -OutFile $deb
        if ((Get-FileHash -LiteralPath $deb -Algorithm SHA256).Hash -ne $package.Hash) {
            throw "SHA-256 mismatch for $($package.Url)"
        }
        & tar.exe -xf $deb -C $work data.tar.xz
        if ($LASTEXITCODE -ne 0) { throw "Failed to unpack $deb" }
        & $SevenZip e -y $xz "-o$work" | Out-Null
        if ($LASTEXITCODE -ne 0) { throw "Failed to decompress $xz" }
        & tar.exe -xf $tar -C $sysroot './usr/include'
        if ($LASTEXITCODE -ne 0) { throw "Failed to extract headers from $tar" }
        Remove-Item -LiteralPath $deb, $xz, $tar
    }
    if (-not (Test-Path -LiteralPath (Join-Path $sysroot 'usr\include\string.h'))) {
        throw 'The downloaded packages did not contain the expected headers.'
    }
    Move-Item -LiteralPath $sysroot -Destination $Destination
    Write-Host "Linux headers installed in $Destination"
}
finally {
    Remove-Item -LiteralPath $work -Recurse -Force
}
