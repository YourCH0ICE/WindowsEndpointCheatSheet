---
title: 1. MFT
authors: 2026-08-16
---
---
### Defenition
**MFT (Master File Table)** – the primary database of the NTFS file system that stores metadata about files and directories, including their names, timestamps, sizes, attributes, and data locations.

---
### Path
The MFT is typically located at
```
C:\$MFT
```
---
### What information does the MFT store?
The MFT can store information about

| Category                        | Fields                                                                                                                                                                   |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Entry Information**           | `Sequence Number`, `Entry Number`, `Is in Use`, `Reference Count`                                                                                                        |
| **Parent Information**          | `Parent Entry Number`, `Parent Sequence Number`, `Parent Path`                                                                                                           |
| **File Information**            | `File Name`, `Extension`, `Is Dir`, `File Size`                                                                                                                          |
| **NTFS Timestamps**             | `Created 0x10`, `Created 0x30`, `Last Modified 0x10`, `Last Modified 0x30`, `Last Record Change 0x10`, `Last Record Change 0x30`, `Last Access 0x10`, `Last Access 0x30` |
| **Alternate Data Streams**      | `Has ADS`, `Is ADS`                                                                                                                                                      |
| **Security / Zone Information** | `Zone ID Contents`                                                                                                                                                       |
| **Reparse Information**         | `Reparse Target`                                                                                                                                                         |
| **Resident Data**               | `Resident Data (Base64, Hex, ASCII)`                                                                                                                                     |
| **Other**                       | `SI<FN`, `u Sec Zeros`, `Copied`                                                                                                                                         |

---
### Usefull Information from the MFT
The forensic value of MFT artifacts varies depending on the investigation. Some artifacts can provide highly valuable evidence, while others may be less useful depending on the context.
##### ⚪ Entry and Parent Entry numbers

> [!question]- Click here
> 
>The <span style="color: #D96C6C;">Entry Number</span> <span style="color: #FFD166;">uniquely identifies</span> a file or folder entry in the MFT table. For example, the file <span style="color: #D96C6C;">malware.exe</span> might have an Entry Number of 97134 – this is its unique identifier within the MFT. 
> 
> The <span style="color: #D96C6C;">Parent Entry Number</span> indicates the <span style="color: #FFD166;">parent directory where the file is currently located</span>. For the same <span style="color: #D96C6C;">malware.exe</span>, this might be 98335, corresponding to the folder <span style="color: #D96C6C;">.\Users\Administrator\AppData\Local\Temp</span>.
> 
> Using 98335 as the <span style="color: #D96C6C;">Entry Number</span>, we can retrieve the entry for the Temp folder itself and see its <span style="color: #D96C6C;">Parent Entry Number</span> – for example, 98334, corresponding to <span style="color: #D96C6C;">.\Users\Administrator\AppData\Local</span>.
> 
> Thus, by <span style="color: #FFD166;">recursively traversing the Parent Entry Numbers</span>, you can <span style="color: #FFD166;">reconstruct the full path</span> to the file – which is especially useful when other artifacts are unavailable. It's important to note that the <span style="color: #D96C6C;">Parent Entry Number</span> reflects the file's <strong>current location</strong>, not where it was <span style="color: #FFD166;">originally created</span> – if the file has been <span style="color: #FFD166;">moved, this value will change</span>.
> 
> ![[Pasted image 20260816134814.png]]
##### ⚪ Parent Path, FileName and Extension

> [!question]- Click here
>
> <span style="color: #D96C6C;">The Parent Path</span> indicates the <span style="color: #FFD166;">full path to the directory</span> containing the file under investigation. This is important because knowing the path allows you to <span style="color: #FFD166;">detect related files in the same directory</span> – for example, temporary exfiltration tools in the same <span style="color: #D96C6C;">Temp</span> folder.
>
> <span style="color: #D96C6C;">The FileName</span> identifies the <span style="color: #FFD166;">name of the file</span> under investigation.
>
> <span style="color: #D96C6C;">The Extension</span> specifies the <span style="color: #FFD166;">file extension</span> – which is important for understanding the file's nature: whether it is an <span style="color: #D96C6C;">executable</span> or something that appears harmless at first glance.
> 
> ![[Pasted image 20260816134627.png]]
> Together, these three fields allow you to <span style="color: #FFD166;">effectively filter files</span> and <span style="color: #FFD166;">identify suspicious entries</span>.
##### ⚪Has Ads, Is ADs

> [!question]- Click here
>
><span style="color: #D96C6C;">Has ADS</span> indicates whether the file being analyzed <span style="color: #FFD166;">has alternative data streams</span>. A value of <span style="color: #D96C6C;">True</span> warrants <span style="color: #FFD166;">further investigation</span> – especially when dealing with suspicious <span style="color: #D96C6C;">.txt</span> files or other files obtained from an external source and potentially used by an attacker.
> 
> <span style="color: #D96C6C;">Is ADS</span> indicates whether the file being analyzed <span style="color: #FFD166;">itself is an alternative data stream</span>. This is useful because if the file size is <span style="color: #FFD166;">less than 1024 bytes</span>, in some cases you can attempt to examine its structure directly.
> 
> Thus, these two parameters allow you to quickly determine during analysis whether a file <span style="color: #FFD166;">may be associated with malicious activity</span> – especially considering that <span style="color: #D96C6C;">ADS-based techniques</span> have been <span style="color: #FFD166;">used repeatedly in real-world attacks</span>.
> ![[Pasted image 20260816134411.png]]
> 
> Links: 
> 1) https://www.proofpoint.com/us/blog/threat-insight/hidden-plain-sight-ta397s-new-attack-chain-delivers-espionage-rats
> 2) https://dailysecurityreview.com/cyber-security/gamaredon-hides-usb-worm-in-ntfs-alternate-data-streams/
> 3) https://attack.mitre.org/groups/G0050/ (T1564.004)
##### ⚪File Size

> [!question]- Click here
> <span style="color: #D96C6C;">FileSize</span> provides insight into the <span style="color: #FFD166;">potential nature of the file</span>. If the file is <span style="color: #FFD166;">small enough to be stored directly within the MFT record</span>, its content may be accessible without additional carving. Beyond residency, file size also helps assess the file's <span style="color: #FFD166;">likely purpose</span> – a <span style="color: #D96C6C;">.ps1</span> script of only a few hundred bytes almost certainly functions as a <span style="color: #D96C6C;">stager</span> or <span style="color: #D96C6C;">downloader</span>, since a fully capable tool would not fit within that size. This <span style="color: #FFD166;">narrows the investigative focus</span> considerably.
> 
> ![[Pasted image 20260816134202.png]]
##### ⚪Timestamps

> [!question]- Click here
> <span style="color: #D96C6C;">Created</span> – time the file was <span style="color: #FFD166;">created</span>.
> 
> <span style="color: #D96C6C;">Last Modified</span> – time the file's <span style="color: #FFD166;">contents were last modified</span>.
> 
> <span style="color: #D96C6C;">Last Record Change</span> – time the <span style="color: #FFD166;">MFT entry itself was last modified</span> – for example, a change to attributes, access permissions, or metadata – not necessarily the contents.
> 
> <span style="color: #D96C6C;">Last Access</span> – time the file was last accessed. </span>
> 
> <span style="color: #D96C6C;">0x10 ($STANDARD_INFORMATION)</span> – timestamps accessible via the standard Windows API. These are the ones visible in File Explorer and <span style="color: #FFD166;">easily modified using any timestomping tool</span>.
> 
> <span style="color: #D96C6C;">0x30 ($FILE_NAME)</span> – timestamps updated at the <span style="color: #FFD166;">Windows kernel level</span>, not directly accessible via the user-mode API. <span style="color: #FFD166;">Most tools do not affect them</span>.
> 
> ![[Pasted image 20260816135630.png]]
> 
> Thus, a <span style="color: #FFD166;">discrepancy between 0x10 and 0x30</span> for the same timestamp is a <span style="color: #FFD166;">strong indicator of intentional timestomping</span>.

 ##### ⚪Zone Id Contents
 
 > [!question]- Click here
> <span style="color: #D96C6C;">Zone Identifier</span> indicates the <span style="color: #FFD166;">origin zone of the file</span>. It can directly point to <span style="color: #FFD166;">where the file was downloaded from</span> – often containing the exact URL, which may reference a <span style="color: #D96C6C;">C2 server</span> or other source relevant to the investigation.
> 
> - <span style="color: #D96C6C;">ZoneId=0</span> – local machine
> - <span style="color: #D96C6C;">ZoneId=1</span> – Intranet
> - <span style="color: #D96C6C;">ZoneId=2</span> – Trusted site
> - <span style="color: #D96C6C;">ZoneId=3</span> – Internet
> 
> <span style="color: #D96C6C;">ZoneId=3</span> is the most valuable in practice, as it frequently contains the <span style="color: #FFD166;">exact download URL</span>.
> 
>
> ![[Pasted image 20260816140538.png]]
 ##### Reparse Target

> [!question]- Click here
> <span style="color: #D96C6C;">Reparse Target</span> stores the <span style="color: #FFD166;">destination of a symbolic link or junction point</span>. Even if the link itself has been deleted, the MFT entry may still retain this value – allowing you to <span style="color: #FFD166;">recover where it pointed</span>.
> 
> This is useful in two ways. First, it helps <span style="color: #FFD166;">reconstruct the original entry point</span> – for example, if an attacker created a symlink to <span style="color: #D96C6C;">redirect access to a privileged file</span>. Second, the presence of <span style="color: #FFD166;">unexpected reparse points</span> in suspicious directories is itself an indicator of potential <span style="color: #D96C6C;">privilege escalation</span> or <span style="color: #D96C6C;">persistence</span> activity.
---

### Analysis Tools

> [!info]- Click here
> The answer depends on the goal. For viewing raw byte data – such as <span style="color: #FFD166;">resident files</span> – any hex editor will suffice, for example <span style="color: #D96C6C;">HexED.it</span>.
> 
> For properly parsing the MFT table, three tools are worth considering:
> 
> **[MFTCmd](https://github.com/EricZimmerman/MFTECmd)** – a <span style="color: #FFD166;">CLI tool</span>, suits experienced users familiar with parsing flags.
> 
> Example command:  
>  ```
>  .\MFTECmd.exe -f C:\Users\<username>\Desktop\C\$MFT --csv C:\Users\<destination_path> --csvf Ready.csv
>  ```
> ![[Pasted image 20260816164841.png]]
> 
> **[MFTExplorer](https://ericzimmerman.github.io/#forensic-tools)** – the <span style="color: #FFD166;">GUI counterpart</span>, better suited for beginners; offers filtering, automatic parsing, and a clean file/folder display.
> ![[Pasted image 20260816165702.png]]
> 
> **[KAPE + MFTECmd_$MFT](https://www.kroll.com/en/services/cyber/reactive-services/kroll-artifact-parser-and-extractor-kape)** — a <span style="color: #FFD166;">KAPE module</span> that automates MFT parsing; requires <span style="color: #D96C6C;">KAPE</span> to be installed.
> 
> Example command: `.\kape.exe --tsource "C:\Users\..." --target $MFT --tdest "..." --module MFTECmd`
> ![[Pasted image 20260816181450.png]]
> 
> *This list reflects the author's personal experience and is not exhaustive.*
### Overall

> [!summary]- Click here
> <span style="color: #D96C6C;">MFT</span> is one of the most valuable artifacts in <span style="color: #FFD166;">digital forensics and incident response</span>. A single table entry can provide file creation timestamps, full directory paths, residency data, ADS indicators, download origins, and symbolic link destinations — making it a <span style="color: #FFD166;">reliable starting point for almost any Windows investigation</span>.
> 
> The real value of MFT lies in its <span style="color: #FFD166;">persistence</span>. I mean even <span style="color: #D96C6C;">deleted files</span> leave traces, <span style="color: #D96C6C;">tampered timestamps</span> can be detected through <span style="color: #FFD166;">0x10/0x30 discrepancies</span>, and <span style="color: #D96C6C;">Zone Identifiers</span> can directly expose <span style="color: #D96C6C;">C2 infrastructure</span>. Combined, these fields allow an investigator to <span style="color: #FFD166;">reconstruct a detailed picture of file activity</span> with minimal reliance on other artifacts.

### Additional Resources

> [!tip]- Click here
> - [DFIR Notes – MFT, NTFS](https://mahmoud-shaker.gitbook.io/dfir-notes/master-file-table-mft-ntfs-usdlogfile-and-usdusnjrnl-forensics)
> - [The MFT – The One Artifact I Check First on Every Windows Investigation](https://mohitdhabuwala17.medium.com/the-mft-the-one-artifact-i-check-first-on-every-windows-investigation-bc1fc32a730e)
> - [MFT Explorer & MFTECmd – AboutDFIR](https://aboutdfir.com/toolsandartifacts/windows/mft-explorer-mftecmd/)


