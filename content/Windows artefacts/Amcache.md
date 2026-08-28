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
The Amcache can store information about: 

| Category                   | Fields                                   | File content                            |
| -------------------------- | ---------------------------------------- | --------------------------------------- |
| File Hash                  | `SHA1`                                   | `*_Amcache_UnassociatedFileEntries.csv` |
| File Path                  | `FullPath`                               | `*_Amcache_UnassociatedFileEntries.csv` |
| File Name                  | `Name`                                   | `*_Amcache_UnassociatedFileEntries.csv` |
| Original File Name         | `OriginalFileName`                       | `*_Amcache_UnassociatedFileEntries.csv` |
| Publisher                  | `Publisher`                              | `*_Amcache_UnassociatedFileEntries.csv` |
| Product Name               | `ProductName`                            | `*_Amcache_UnassociatedFileEntries.csv` |
| File Version               | `Version`                                | `*_Amcache_UnassociatedFileEntries.csv` |
| File Size                  | `Size`                                   | `*_Amcache_UnassociatedFileEntries.csv` |
| PE File                    | `IsPeFile`                               | `*_Amcache_UnassociatedFileEntries.csv` |
| Windows Component          | `IsOsComponent`                          | `*_Amcache_UnassociatedFileEntries.csv` |
| PE Compile / Link Time     | `LinkDate`                               | `*_Amcache_UnassociatedFileEntries.csv` |
| Amcache Record Timestamp   | `FileKeyLastWriteTimestamp`              | `*_Amcache_UnassociatedFileEntries.csv` |
| Program Association        | `ProgramId`                              | `*_Amcache_UnassociatedFileEntries.csv` |
| USN Reference              | `Usn`                                    | `*_Amcache_UnassociatedFileEntries.csv` |
| Driver Hash                | `DriverId`                               | `*_Amcache_DriveBinaries.csv`           |
| Driver Name                | `DriverName`                             | `*_Amcache_DriveBinaries.csv`           |
| Driver Company             | `DriverCompany`                          | `*_Amcache_DriveBinaries.csv`           |
| Driver Signature           | `DriverSigned`                           | `*_Amcache_DriveBinaries.csv`           |
| Kernel Driver              | `DriverIsKernelMode`                     | `*_Amcache_DriveBinaries.csv`           |
| Inbox Driver               | `DriverInBox`                            | `*_Amcache_DriveBinaries.csv`           |
| Driver Timestamp           | `DriverLastWriteTime`, `DriverTimeStamp` | `*_Amcache_DriveBinaries.csv`           |
| Driver Version             | `DriverVersion`                          | `*_Amcache_DriveBinaries.csv`           |
| Driver Service             | `Service`                                | `*_Amcache_DriveBinaries.csv`           |
| Driver INF                 | `Inf`                                    | `*_Amcache_DriveBinaries.csv`           |
| Driver Record Timestamp    | `KeyLastWriteTimestamp`                  | `*_Amcache_DriveBinaries.csv`           |
| Device Hardware ID         | `HWID`                                   | `*_Amcache_DevicePnps.csv`              |
| Device Container ID        | `ContainerId`                            | `*_Amcache_DevicePnps.csv`              |
| Device Description         | `Description`                            | `*_Amcache_DevicePnps.csv`              |
| Device Manufacturer        | `Manufacturer`                           | `*_Amcache_DevicePnps.csv`              |
| Device Model               | `Model`                                  | `*_Amcache_DevicePnps.csv`              |
| Device Class               | `Class`, `ClassGuid`                     | `*_Amcache_DevicePnps.csv`              |
| Device Enumerator          | `Enumerator`                             | `*_Amcache_DevicePnps.csv`              |
| Device Driver              | `DriverName`, `DriverId`                 | `*_Amcache_DevicePnps.csv`              |
| Device Service             | `Service`                                | `*_Amcache_DevicePnps.csv`              |
| Device INF                 | `Inf`                                    | `*_Amcache_DevicePnps.csv`              |
| Device Record Timestamp    | `KeyLastWriteTimestamp`                  | `*_Amcache_DevicePnps.csv`              |
| Device Friendly Name       | `FriendlyName`                           | `*_Amcache_DeviceContainers.csv`        |
| Device Manufacturer        | `Manufacturer`                           | `*_Amcache_DeviceContainers.csv`        |
| Device Model               | `ModelName`                              | `*_Amcache_DeviceContainers.csv`        |
| Device Category            | `PrimaryCategory`                        | `*_Amcache_DeviceContainers.csv`        |
| Device State               | `IsConnected`, `IsPaired`, `IsActive`    | `*_Amcache_DeviceContainers.csv`        |
| Device Container Timestamp | `KeyLastWriteTimestamp`                  | `*_Amcache_DeviceContainers.csv`        |
| Driver Package INF         | `Inf`                                    | `*_Amcache_DriverPackages.csv`          |
| Driver Package SYS File    | `SYSFILE`                                | `*_Amcache_DriverPackages.csv`          |
| Driver Package Provider    | `Provider`                               | `*_Amcache_DriverPackages.csv`          |
| Driver Package Directory   | `Directory`                              | `*_Amcache_DriverPackages.csv`          |
| Driver Package HWIDs       | `Hwids`                                  | `*_Amcache_DriverPackages.csv`          |
| Driver Package Version     | `Version`                                | `*_Amcache_DriverPackages.csv`          |
| Driver Package Date        | `Date`                                   | `*_Amcache_DriverPackages.csv`          |
| Shortcut Name              | `LnkName`                                | `*_Amcache_ShortCuts.csv`               |
| Shortcut Timestamp         | `KeyLastWriteTimestamp`                  | `*_Amcache_ShortCuts.csv`               |

---
### Analysis Tools

> [!info]- Click here
> For parsing `Amcache.hve`, you can use **AmcacheParser**, which can parse the artifact into JSON or CSV files. After successful parsing, you can use **Timeline Explorer** or any other CSV/JSON editor capable of correctly displaying the file's contents for filtering and analysis.
> 
> **[AmcacheParser](https://github.com/EricZimmerman/AmcacheParser)** – CLI tool for parsing `Amcache.hve`.
> 
> Example command: 
> ```
> .\AmcacheParser.exe -f C:\Windows\appcompat\Programs\Amcache.hve --csv C:\<destination_path>\File_name.csv
> ```
> ![[Pasted image 20260828203839.png]]
>  
> In addition, as mentioned earlier, you can use the ready-made <span style="color: #D96C6C;">[KAPE](https://www.kroll.com/en/services/cyber/reactive-services/kroll-artifact-parser-and-extractor-kape)</span> module – <span style="color: #D96C6C;">AmcacheParser</span>. Once parsing is complete, you'll receive a file in <span style="color: #FFD166;">CSV or JSON format</span>, depending on the selected settings.
> ![[Pasted image 20260828224405.png]]

### Overall

> [!summary]- Overall
> Overall, <span style="color: #D96C6C;">Amcache.hve</span> is an <span style="color: #FFD166;">extremely valuable forensic artifact</span> for identifying applications, executables, drivers, and installed software that have been observed on a Windows system. It can provide investigators with <span style="color: #FFD166;">file paths, program metadata, timestamps, and SHA-1 hashes</span>, allowing files to be identified and correlated with other forensic evidence or threat intelligence sources. Of particular interest are <span style="color: #D96C6C;">Unassociated File Entries</span>, which may highlight <span style="color: #FFD166;">standalone, portable, or otherwise unusual executables</span> that are not linked to a known installed application. When <span style="color: #FFD166;">correlated with additional artifacts</span>, Amcache can significantly improve the <span style="color: #FFD166;">reconstruction of historical application activity</span> and help identify software that may no longer be present on the system.
### Additional Resources

> [!tip]- Additional Information
> - https://forensafe.com/blogs/AmCache.html 
> - https://securelist.com/amcache-forensic-artifact/117622/ 
> - https://kb.binalyze.ai/air/features/acquisition/supported-evidence/windows-collections-detail/amcache 
