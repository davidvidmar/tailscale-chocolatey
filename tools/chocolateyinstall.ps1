$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Get-ChildItem -Path "$toolsDir\tailscale.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher

$packageArgs = @{
  SoftwareName   = 'Tailscale'
  PackageName    = $env:ChocolateyPackageName
  UnzipLocation  = $toolsDir
  FileType       = 'msi'

  silentArgs     = '/quiet'
  validExitCodes = @(0)
}

if ($env:PROCESSOR_IDENTIFIER.StartsWith('ARMv')) {
  # Windows on ARM
  $packageArgs += @{
    Url          = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.50.1-arm64.msi'
    Checksum     = 'c50e8dc3bc3b43fb75935c4e190851c05f4b758103ad3b836a98da1cab3cdbc1'
    ChecksumType = 'sha256'
  }
}
else {
  # Windows on x86 or x64
  $packageArgs += @{
    Url            = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.50.1-x86.msi'
    Checksum       = '3e41c0c6de561334a54b618a38d1924433a5acb07d8310ab350486e3d0b06460'
    ChecksumType   = 'sha256'

    Url64Bit       = 'https://pkgs.tailscale.com/stable/tailscale-setup-1.50.1-amd64.msi'
    Checksum64     = '13f6379786f85ff4525f06573d17455263275f5aa1196753f2ff40445b8ebc08'
    ChecksumType64 = 'sha256'
  }
}

Install-ChocolateyPackage @packageArgs
