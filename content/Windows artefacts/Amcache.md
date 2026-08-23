---
title: 3. Amcache
authors: 2026-08-17
---
---
### Definition

The <span style="color: #D96C6C;">Amcache.hve</span> is a registry hive file that stores information related to <span style="color: #FFD166;">program execution and application activity when a user performs certain actions, such as running host-based applications, installing drivers or new applications, or executing portable applications from external devices.</span> The data contained in the file may include executable paths, installation and execution timestamps, deletion-related information, and <span style="color: #D96C6C;">SHA-1 hash values</span> associated with executable files. These SHA-1 hashes can be used to identify specific files and correlate them with other forensic artifacts or threat intelligence sources, helping investigators determine whether a particular executable is known, suspicious, or malicious.

> [!info]- Click here
> The AmCache computes the SHA-1 hash over **<span style="color: #D96C6C;">only the first 31,457,280 bytes (≈31 MB)</span>** of each executable, so comparing its stored hash online can fail for files exceeding this size. 
#### **Structure**

The <span style="color: #D96C6C;">AmCache.hve</span> file is a registry hive file. The registry file format is a binary file analogous to a filesystem, with a group of keys, subkeys and values. These files are used by the operating system to store user, system, and application configurations.

---
### Path
```
C:\Windows\appcompat\Programs\Amcache.hve 
```
After export via tools such as KAPE:
```
C:\Windows\AppCompat\Programs\Amcache.hve 
```

---
### What information does the Amcache store?
The Amcachecan store information about: 

| Category                          | Fields                    |
| --------------------------------- | ------------------------- |
| Program identifier                | `ProgramID`               |
| Application name                  | `ProgramName`             |
| Application version               | `Version`                 |
| Software publisher                | `Publisher`               |
| Installation directory            | `RootDirPath`             |
| Installation date                 | `InstallDate`             |
| Registry key modification time    | `KeyLastWriteTime`        |
| UWP package name                  | `PackageFullName`         |
| Installation source               | `InstallSourceType`       |
| MSI product code GUID             | `MSIProductCode`          |
| MSI package code GUID             | `MSIPackageCode`          |
| Uninstall registry key            | `UninstallKey`            |
| Uninstall command                 | `UninstallString`         |
| Associated program ID             | `ProgramID`               |
| File identifier (SHA1)            | `FileID`                  |
| Product name from file metadata   | `ProductName`             |
| Product version                   | `ProductVersion`          |
| File name                         | `Name`                    |
| Lowercase long path               | `FilePath`                |
| Original file name from PE header | `OriginalFileName`        |
| SHA1 hash                         | `SHA1`                    |
| Publisher name                    | `Publisher`               |
| File size in bytes                | `FileSize`                |
| Update Sequence Number            | `USN`                     |
| Whether file is OS component      | `IsOsComponent`           |
| Registry key modification time    | `KeyLastWriteTime`        |
| Registry key name                 | `KeyName`                 |
| Path to shortcut file             | `LNKPath`                 |
| Registry key modification time    | `KeyLastWriteTime`        |
| Device identifier                 | `KeyName`                 |
| Device class                      | `Class`                   |
| Device description                | `Description`             |
| Driver name                       | `DriverName`              |
| Driver package identifier         | `DriverPackageStrongName` |
| Device model                      | `Model`                   |
| First installation date           | `FirstInstallDate`        |
| Last installation date            | `InstallDate`             |
| Registry key modification time    | `KeyLastWriteTime`        |
| Device manufacturer               | `Manufacturer`            |
| Driver provider                   | `Provider`                |
| Associated service                | `Service`                 |
| Driver version date               | `DriverVerDate`           |
| Driver version                    | `DriverVerVersion`        |
| Hardware ID                       | `HWID`                    |
| INF file name                     | `Inf`                     |
| Parent device ID                  | `ParentID`                |
| Driver identifier                 | `DriverID`                |
| Container ID GUID                 | `ContainerID`             |
| Class GUID                        | `ClassGuid`               |
| Compatible IDs                    | `COMPID`                  |
| Bus-reported description          | `BusReportedDescription`  |
| Driver key name                   | `KeyName`                 |
| Product name                      | `Product`                 |
| Product version                   | `ProductVersion`          |
| Driver file name                  | `DriverName`              |
| Driver version                    | `DriverVersion`           |
| Driver package identifier         | `DriverPackageStrongName` |
| Driver company                    | `DriverCompany`           |
| Driver last write time            | `DriverLastWriteTime`     |
| Driver timestamp                  | `DriverTimeStamp`         |
| Registry key modification time    | `KeyLastWriteTime`        |
| Whether driver is kernel-mode     | `DriverIsKernelMode`      |
| Whether driver is signed          | `DriverSigned`            |
| Associated service                | `Service`                 |
| INF file name                     | `Inf`                     |
| Driver identifier                 | `DriverId`                |
| Driver checksum                   | `DriverCheckSum`          |
| Driver image size                 | `ImageSize`               |
| Volume GUID                       | `VolumeID`                |
| File entry identifier             | `FileID`                  |
| Associated program ID             | `ProgramID`               |
| Product name                      | `ProductName`             |
| Company name                      | `CompanyName`             |
| File path                         | `FilePath`                |
| File description                  | `FileDescription`         |
| File version                      | `FileVersion`             |
| File size in bytes                | `FileSize`                |
| SHA1 hash                         | `SHA1`                    |
| PE compilation timestamp          | `CompilationTime`         |
| File modification time            | `FileModificationTime`    |
| File creation time                | `FileCreationTime`        |
| Amcache entry creation            | `EntryCreationTime`       |
| Registry key modification time    | `KeyLastWriteTime`        |
| MFT entry number                  | `MFTEntryNumber`          |
| MFT sequence number               | `MFTSequenceNumber`       |
| Program identifier                | `ProgramID`               |
| Space-separated list of file IDs  | `VolumeIDFileID`          |
| Program name                      | `ProgramName`             |
| Program version                   | `ProgramVersion`          |
| Space-separated file paths        | `FilePaths`               |
| Publisher name                    | `Publisher`               |
| Installation date                 | `InstallDate`             |
| Registry key modification time    | `KeyLastWriteTime`        |
| Installation source type          | `InstallSourceType`       |
| Uninstall registry keys           | `UninstallKeys`           |
| Product code GUID                 | `ProductCode`             |
| Package code GUID                 | `PackageCode`             |
| MSI product codes                 | `MSIProductCodes`         |
| MSI package codes                 | `MSIPackageCodes`         |

---
### Usefull Information from the Amcache

##### ⚪ FileAttribute

> [!question]- Click here
> <span style="color: #D96C6C;">FileAttribute</span> is a <span style="color: #FFD166;">32-bit unsigned integer</span> describing the type and properties of the object associated with the record. It identifies whether we are dealing with a file or directory, and what attributes it carries – such as hidden, system, archive, or sparse. Attributes of associated streams are excluded.
> 
> For a full list of valid attributes: [Microsoft Documentation](https://learn.microsoft.com/zh-cn/openspecs/windows_protocols/ms-fscc/ca28ec38-f155-4768-81d6-4bfeb8586fc9)

---
### Analysis Tools

> [!info]- Click here
> As with MFT, you can use <span style="color: #D96C6C;">MFTCmd</span> to parse `$J` – it handles this without any issues. After successful parsing, use <span style="color: #D96C6C;">Timeline Explorer</span> or any other <span style="color: #FFD166;">CSV/JSON editor</span> capable of correctly displaying the file's contents for <span style="color: #FFD166;">filtering and analysis</span>.
> 
> **[MFTCmd](https://github.com/EricZimmerman/MFTECmd)** – CLI tool for parsing `$J`.
> 
> Example command: `.\MFTECmd.exe -f C:\Users\Choice\Desktop\C\Extend\J --csv . --csvf J.csv`
> ![[Pasted image 20260817132743.png]]
> ![[Pasted image 20260817132837.png]]
> 
> In addition, as mentioned earlier, you can use the ready-made <span style="color: #D96C6C;">[KAPE](https://www.kroll.com/en/services/cyber/reactive-services/kroll-artifact-parser-and-extractor-kape)</span> module – <span style="color: #D96C6C;">MFTECmd_$J</span>. Once parsing is complete, you'll receive a file in <span style="color: #FFD166;">CSV or JSON format</span>, depending on the selected settings.
> ![[Pasted image 20260817132815.png]]

### Overall

> [!summary]- Overall
> Overall, <span style="color: #D96C6C;">Amcache.hve</span> is an <span style="color: #FFD166;">extremely valuable forensic artifact</span> for identifying applications, executables, drivers, and installed software that have been observed on a Windows system. It can provide investigators with <span style="color: #FFD166;">file paths, program metadata, timestamps, and SHA-1 hashes</span>, allowing files to be identified and correlated with other forensic evidence or threat intelligence sources. Of particular interest are <span style="color: #D96C6C;">Unassociated File Entries</span>, which may highlight <span style="color: #FFD166;">standalone, portable, or otherwise unusual executables</span> that are not linked to a known installed application. When <span style="color: #FFD166;">correlated with additional artifacts</span>, Amcache can significantly improve the <span style="color: #FFD166;">reconstruction of historical application activity</span> and help identify software that may no longer be present on the system.
### Additional Resources

> [!tip]- Additional Information
> - https://forensafe.com/blogs/AmCache.html 
> - https://securelist.com/amcache-forensic-artifact/117622/ 
> - https://kb.binalyze.ai/air/features/acquisition/supported-evidence/windows-collections-detail/amcache 
