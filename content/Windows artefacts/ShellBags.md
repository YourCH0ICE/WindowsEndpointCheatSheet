---
title: 7. ShellBags
authors: 2026-09-01
---
---
### Definition

<span style="color: #D96C6C;">Shellbags</span> are <span style="color: #FFD166;">Windows Registry artifacts that store information about the view settings and preferences of folders accessed via Windows File Explorer</span>. While Microsoft designed them to give users a consistent visual experience by remembering a folder's icon size, window position, and view mode, they have become one of the most critical sources of evidence in **digital forensics and incident response (DFIR)**

---
### Path 

In Windows, information about Shellbags is stored in the NTUSER.DAT registry hive. 
```
NTUSER.DAT\Software\Microsoft\Windows\Shell\BagMRU
NTUSER.DAT\Software\Microsoft\Windows\Shell\Bags
```

> [!info]- Click here
> NTUSER.DAT file path: `C:\Users\<Username>\NTUSER.DAT`

Shellbags artifacts are also found in UsrClass.dat hive at the following locations:
```
USRCLASS.DAT\Local Settings\Software\Microsoft\Windows\Shell\BagMRU
USRCLASS.DAT\Local Settings\Software\Microsoft\Windows\Shell\Bags 
```

> [!info]- Click here
> USRCLASS.DAT file path: `C:\Users\<Username>\AppData\Local\Microsoft\Windows\UsrClass.dat`

---
### What information do ShellBags store?

ShellBags can store information about:

- **Folder names** – names of directories that were viewed or accessed through Windows Explorer.

- **Folder paths and hierarchy** – the structure of directories, allowing reconstruction of paths such as `C:\Users\<Username>\Documents\Projects`.   

- **Local drives and folders** – directories located on internal disks.
 
- **Removable media** – folders accessed on USB drives, external disks, and other removable storage.

- **Network locations** – accessed network shares and UNC paths such as `\\SERVER\Share\Folder`

- **Deleted or unavailable folders** – ShellBag entries may remain even after the original folder has been deleted, the USB device has been disconnected, or the network share is no longer available.
    
- **Shell Item type** – information about the type of object, such as a directory, drive, network location, archive, control panel item, or other Windows Shell object.

- **Folder timestamps** – Shell Items may contain filesystem timestamps such as:
    - `Created`
    - `Modified`
    - `Accessed`

- **MFT information** – some Shell Items contain:
    - `MFT Entry Number`
    - `MFT Sequence Number`
    These values can help correlate a ShellBag entry with a specific NTFS `$MFT` record.

- **MRU order** – `MRUListEx` records the relative order in which child Shell items were used. The first item in the list represents the most recently used child object within that particular ShellBag node.

- **Registry LastWrite timestamps** – indicate when a ShellBag-related registry key was last modified and may help establish a timeline of folder interaction.

- **Explorer view settings** – the `Bags` structure stores information about how a folder was displayed in Windows Explorer, including:
    - View mode (`Details`, `List`, `Tiles`, `Icons`, etc.)
    - Icon size
    - Icon positions
    - Sort order
    - Column configuration
    - Column widths
    - Other folder-specific display settings

- **Archive browsing information** – archives such as ZIP files may appear in ShellBags when Windows Explorer treats them as folders.

- **Virtual Shell locations** – ShellBags may contain objects that do not correspond directly to a normal filesystem directory, such as `Desktop`, `This PC`, Control Panel locations, libraries, and other Shell namespace objects.
### Important forensic point

ShellBags are especially useful for identifying **historical folder interaction**. They can provide evidence that a directory, removable drive, network share, or other Shell object was previously visible or accessed through Windows Explorer, even when that object is no longer present.

However, a ShellBag entry **does not by itself prove that a specific file was opened, copied, executed, or deleted**.

Also, the `Created`, `Modified`, and `Accessed` timestamps stored inside a Shell Item should not automatically be interpreted as the exact time when the user opened the folder. They are filesystem-related timestamps captured within the Shell Item and should be correlated with other artifacts.

---
### Useful Information from the ShellBags 

The forensic value of ShellBags depends on the investigation, but they are especially useful for reconstructing **user interaction with folders and locations that may no longer exist on the system.** Based on our investigative experience, the following information is among the most valuable.

⚪ Deleted & Historical Folders

> [!question]- Click here  
> ShellBags can preserve information about folders even after those folders have been deleted from the filesystem. This may allow an investigator to recover the **folder name, original path and directory structure** long after the original data is no longer present.
> 
> This is particularly useful when investigating suspicious staging directories, temporary working folders, or locations that may have been removed during cleanup activity.
> 

⚪ User Navigation & Bag Path

> [!question]- Click here  
> The **Bag Path** represents the hierarchical structure of folders with which the user interacted. By examining the relationship between entries under `BagMRU`, an investigator can reconstruct how the user navigated through a directory structure.
> 
> For example, instead of simply identifying a single suspicious folder, ShellBags may reveal the complete navigation chain leading to it:
> 
> `Documents → Project → Archive → Secret`
> 
> This can help reconstruct the user's activity and identify additional directories that should be investigated.
> 
> ![[Pasted image 20260906133835.png]]

⚪ External Devices, Network Shares & Archives

> [!question]- Click here  
> ShellBags are not limited to folders located on the local system. They may also contain evidence of interaction with **removable drives, external disks, network shares and ZIP archives**.
> 
> This can be particularly valuable when investigating possible data staging or movement. Even if an external device has been disconnected or a network location is no longer available, references to folders browsed through the Windows shell may remain in ShellBags.
> 
> Examples of interesting paths include:
> 
> `E:\Documents\Confidential`
> 
> `\\vmware-host\Shared Folders`
> 
> ![[Pasted image 20260906133147.png]] 
> 
> `C:\Users\User\Downloads\Archive.zip`
> 
> 
> 

⚪ Interaction Timestamps & MRU Information

> [!question]- Click here
> ShellBag parsers can provide several timestamps and MRU-related fields that help place folder interaction into an investigation timeline.
>
> Of particular interest are **First Interacted**, **Last Interacted**, Registry Last Write information and **MRU Position**. An MRU Position of `0` indicates the most recently referenced child within that particular parent BagMRU entry.
>
> ![[Pasted image 20260906133918.png]]
>
> The **Detailed Information** view may contain additional forensic metadata that is not immediately visible in the Summary view. Depending on the Shell Item type, this can include:
>
> - **MFT Entry Number** – identifies the corresponding NTFS `$MFT` record associated with the directory.
> - **MFT Sequence Number** – helps distinguish between different uses of the same MFT record number if that record was deleted and later reused.
> - **Created / Modified / Accessed timestamps** – filesystem timestamps captured from the target directory when the Shell Item was created.
> - **Shell Item Type** – provides information about the type of object represented by the entry, such as a directory, drive, network location or other Shell namespace object.
> - **MRU Position** – indicates the relative order of child entries within the parent `BagMRU`.
> - **Node Slot** – links the `BagMRU` entry to its corresponding entry under the `Bags` Registry key, where folder view information may be stored.
>
> ![[Pasted image 20260906134023.png]]
>
> The combination of the **MFT Entry Number and MFT Sequence Number** can be particularly valuable during correlation. If the `$MFT` is available, an investigator can use these values to identify the corresponding filesystem record and compare the ShellBag evidence with other NTFS artifacts such as `$MFT` and `$UsnJrnl`.
>
> For example:
>
> `MFT Entry Number: 559`
>
> `MFT Sequence Number: 6`
>
> This indicates that the Shell Item referenced MFT record `559` with sequence number `6`. The sequence number is important because NTFS can reuse an MFT record after the original file or directory is deleted; a different sequence number can therefore indicate that the same MFT entry number now belongs to a different filesystem object.
>
> Be careful when interpreting timestamps: the `Created`, `Modified` and `Accessed` values associated with a Shell Item generally represent filesystem metadata captured from the target object. They should **not automatically be interpreted as the exact time when the user opened or browsed the folder**.

> [!error]- Important Limitation  
> ShellBags primarily provide evidence of **folder-level interaction through the Windows shell**, such as Windows Explorer or certain Open/Save dialogs.
> 
> They should **not** be treated as evidence that a specific file inside the folder was opened or executed.
> 
> Navigation performed through tools such as **Command Prompt or PowerShell** may not generate corresponding ShellBag entries. Therefore, the absence of a ShellBag does not necessarily mean that the directory was never accessed.
> 
> ShellBags should be correlated with other artifacts such as `$MFT`, `$UsnJrnl`, Jump Lists, LNK files, RecentDocs, Prefetch and SRUM when reconstructing user activity.

### Analysis Tools

> [!info]- Click here
> For parsing `ShellBags`, you can use **ShellBags**, which can parse the artifact into JSON or CSV files. After successful parsing, you can use **Timeline Explorer** or any other CSV/JSON editor capable of correctly displaying the file's contents for filtering and analysis.
> 
> **[ShellBags](https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip)** – GUI tool for parsing **ShellBags**`.
> 
> ![[Pasted image 20260906131008.png]]
> 
> 
> [SBECmd](https://ericzimmerman.github.io/) – command-line parser for exporting ShellBag data.
> 
> ![[Pasted image 20260906142842.png]] 
> 
> `Registry Explorer` can also be used to manually examine the underlying **ShellBag Registry** data. The relevant `BagMRU` structure consists primarily of numerically named subkeys and values such as: `0`, `1`, `2`, `3`, ... These numbers represent positions within the hierarchical `BagMRU` tree and **are not the actual folder names**. The corresponding Registry values contain encoded binary Shell Item structures from which information such as folder names and other metadata can be recovered. For example: `BagMRU\1\1\6\0` may represent several levels of folder navigation, but the Registry path itself is not immediately meaningful to an investigator. For this reason, <span style="color: #FFD166;">Registry Explorer is especially useful for **manual validation and examination of the original Registry data**</span>, while tools such as ShellBags Explorer are generally more convenient for reconstructing and reviewing ShellBag activity in a human-readable form.
> 
> ![[Pasted image 20260906140414.png]]
> 
> In addition, as mentioned earlier, you can use the ready-made <span style="color: #D96C6C;">[KAPE](https://www.kroll.com/en/services/cyber/reactive-services/kroll-artifact-parser-and-extractor-kape)</span> module – <span style="color: #D96C6C;">ShellBags Parser</span>. Once parsing is complete, you'll receive a file in <span style="color: #FFD166;">CSV or JSON format</span>, depending on the selected settings.
> 
### Overall

> [!summary]- Overall
><span style="color: #D96C6C;">**Windows ShellBags**</span>  are <span style="color: #FFD166;">crucial user-activity artifacts in digital forensics that store information about the display preferences and layout of folders viewed in Windows File Explorer</span>. Every time a user opens a folder, changes icon size, or adjusts window positions, Windows automatically generates or updates a ShellBag to ensure those visual preferences stick.
### Additional Resources

> [!tip]- Click here
> - [Shellbags Analysis](https://medium.com/ce-digital-forensics/shellbag-analysis-18c9b2e87ac7)
> - [DFIR tools and techniques for tracing user footprints through Shellbags](https://www.pentestpartners.com/security-blog/dfir-tools-and-techniques-for-tracing-user-footprints-through-shellbags/)

