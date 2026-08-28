---
title: 2. $UsnJournal
---
---
### Defenition
<span style="color: #D96C6C;">USN Journal</span> — a <span style="color: #FFD166;">logging mechanism</span> built into NTFS that <span style="color: #FFD166;">tracks every change</span> made to files and folders on NTFS and ReFS volumes. Each record captures what happened — whether a file was <span style="color: #D96C6C;">created</span>, <span style="color: #D96C6C;">deleted</span>, or <span style="color: #D96C6C;">modified</span> — and when. New entries are <span style="color: #FFD166;">appended sequentially</span>, meaning the journal <span style="color: #FFD166;">survives system crashes</span> and can be recovered to <span style="color: #FFD166;">reconstruct a timeline of filesystem activity</span>

#### Structure

\$<span style="color: #D96C6C;">UsnJrnl</span> acts as a container holding two alternative data streams: \$<span style="color: #D96C6C;">J</span> and \$<span style="color: #D96C6C;">Max</span>.

\$<span style="color: #D96C6C;">J</span> – the primary stream, stores a <span style="color: #FFD166;">record of every change made to files</span> across the system.

\$<span style="color: #D96C6C;">Max</span> – stores <span style="color: #FFD166;">configuration data</span> about \$<span style="color: #D96C6C;">J</span> itself. On extraction it exposes the following:

- <span style="color: #D96C6C;">Maximum USN Size</span> – the <span style="color: #FFD166;">maximum journal size</span> (in this case 32 MB)
- <span style="color: #D96C6C;">Allocation Size</span> – the chunk size allocated when the journal <span style="color: #FFD166;">expands</span> (8 MB)
- <span style="color: #D96C6C;">USN ID</span> – a <span style="color: #FFD166;">unique identifier</span> for the journal
- <span style="color: #D96C6C;">Lowest Valid USN</span> – the minimum valid USN value; entries below it have been <span style="color: #FFD166;">overwritten</span>
---
### Path
```
C:\$Extend\$UsnJrnl — the primary metadata container
C:\$Extend\$UsnJrnl:$J` — data stream containing journal records
C:\$Extend\$UsnJrnl:$Max` — data stream containing configuration metadata
```
After export via tools such as KAPE:
```
C:\$Extend\$J — exported $J stream containing journal records
C:\$Extend\$UsnJrnl — exported $Max stream containing configuration metadata
```

> [!info]- Click here
> When using `KAPE`, `$UsnJrnl` is <span style="color: #FFD166;">not exported as a whole</span> – instead, its `$J` and `$Max` streams are saved as <span style="color: #FFD166;">separate files</span>.

---
### What information does the $J store?
The $J can store information about

| Category              | Fields                                |
| --------------------- | ------------------------------------- |
| **File Information**  | `Name`, `Extension`                   |
| **Entry Information** | `Entry Number`, `Parent Entry Number` |
| **Timestamps**        | `Update Timestamp`                    |
| **Journal Metadata**  | `Update Sequence Number`              |
| **Change Tracking**   | `Update Reasons`                      |
| **File Attributes**   | `FileAttribute`                       |

---
### Usefull Information from the $J
It is worth noting that the fields described below represent what we consider the most valuable for analysis. However, their effectiveness depends entirely on the case at hand.
##### ⚪ Update Timestamp

> [!question]- Click here
> <span style="color: #D96C6C;">Update Timestamp</span> indicates the time a specific file was <span style="color: #FFD166;">last updated</span>. This timestamp correlates with MFT and can serve as a <span style="color: #FFD166;">secondary – or in some cases primary – source</span> when the MFT file is unavailable or corrupted.
> ![[Pasted image 20260817124303.png]]

##### ⚪ Name & Extension

> [!question]- Click here
> <span style="color: #D96C6C;">Name</span> directly identifies the <span style="color: #FFD166;">current name of the file</span> at the time the record was written.
> 
> <span style="color: #D96C6C;">Extension</span> specifies the file extension – important for understanding the file's nature: whether it is an <span style="color: #D96C6C;">executable</span> or something that <span style="color: #FFD166;">appears harmless at first glance</span>.
> ![[Pasted image 20260817125530.png]]

##### ⚪ Entry Number & Parent Entry Number

> [!question]- Click here
> <span style="color: #D96C6C;">Entry Number</span> and <span style="color: #D96C6C;">Parent Entry Number</span> function similarly to their MFT counterparts – uniquely identifying the file record and its parent directory. However, unlike MFT, <span style="color: #FFD166;">$J does not store the full file path directly</span>. Instead, the <span style="color: #D96C6C;">Parent Entry Number</span> can be used to <span style="color: #FFD166;">identify the working directory</span> of a file by correlating it with MFT – allowing you to successfully reconstruct the path.
> ![[Pasted image 20260817125611.png]]

##### ⚪ Update Sequence Number

> [!question]- Click here
> <span style="color: #D96C6C;">Update Sequence Number</span> is a <span style="color: #FFD166;">unique 64-bit identifier</span> assigned to each journal record. It increments monotonically with every new change entry, serving to <span style="color: #FFD166;">distinguish records from one another</span> and to track read progress through the journal.
> ![[Pasted image 20260817130040.png]]

##### ⚪ Update Reasons

> [!question]- Click here
> <span style="color: #D96C6C;">Update Reasons</span> indicates <span style="color: #FFD166;">what actually happened</span> to a given file. The most relevant values include:
> 
> - `USN_REASON_FILE_CREATE` – the file or directory was <span style="color: #FFD166;">created for the first time</span>
> - `USN_REASON_FILE_DELETE` – the file or directory was <span style="color: #FFD166;">deleted</span>
> - `USN_REASON_DATA_OVERWRITE` – the data was <span style="color: #FFD166;">overwritten</span>
> - `USN_REASON_DATA_EXTEND` – the file was <span style="color: #FFD166;">extended</span>
> - `USN_REASON_DATA_TRUNCATION` – the file was <span style="color: #FFD166;">truncated</span>
> - `USN_REASON_BASIC_INFO_CHANGE` – attributes or <span style="color: #FFD166;">timestamps were modified</span>
> - `USN_REASON_ENCRYPTION_CHANGE` – the file was <span style="color: #FFD166;">encrypted or decrypted</span>
> - `USN_REASON_CLOSE` – the file or directory was <span style="color: #FFD166;">closed</span>
> 
> Particularly valuable are:
> - `USN_REASON_RENAME_OLD_NAME` – captures the <span style="color: #FFD166;">previous name</span> before a rename
> - `USN_REASON_RENAME_NEW_NAME` – captures the <span style="color: #FFD166;">new name</span> after a rename
> 
> These two allow you to <span style="color: #FFD166;">track file renames</span> and maintain investigative continuity – especially when log sources were tampered with or rename commands were not preserved.
> 
> ![[Pasted image 20260817130550.png]]
> 
> For a full list of reason codes: [Microsoft Documentation](https://learn.microsoft.com/th-th/windows/win32/api/winioctl/ns-winioctl-usn_record_v4#1)

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
> Example command: 
> ```
>.\MFTECmd.exe -f C:\Users\<username>\Desktop\C\Extend\J --csv . --csvf C:\<destination_path>\J.csv
> ```
> ![[Pasted image 20260817132743.png]]
> ![[Pasted image 20260817132837.png]]
> 
> In addition, as mentioned earlier, you can use the ready-made <span style="color: #D96C6C;">[KAPE](https://www.kroll.com/en/services/cyber/reactive-services/kroll-artifact-parser-and-extractor-kape)</span> module – <span style="color: #D96C6C;">MFTECmd_$J</span>. Once parsing is complete, you'll receive a file in <span style="color: #FFD166;">CSV or JSON format</span>, depending on the selected settings.
> ![[Pasted image 20260817132815.png]]

### Overall

> [!summary]- Overall
> Overall, `$J` is an <span style="color: #FFD166;">extremely valuable artifact</span> – particularly in situations where the <span style="color: #FFD166;">MFT is unavailable or corrupted</span>. In practice, it has consistently delivered results even under those constraints. While slightly more limited than <span style="color: #D96C6C;">MFT</span>, it serves as a <span style="color: #FFD166;">reliable substitute</span> and, when <span style="color: #FFD166;">correlated with MFT fields</span>, significantly increases the <span style="color: #FFD166;">accuracy of the investigation</span>.

### Additional Resources

> [!tip]- Additional Information
> - [USN Journal Forensics – Forensafe](https://forensafe.com/blogs/usnjournal.html)
> - [NTFS Journaling in Digital Forensics – CyberEngage](https://www.cyberengage.org/post/ntfs-journaling-in-digital-forensics-logfile-usnjrnl-parsing-of-j-logfile-using-mftecmd-ex)
> - [USN Journal Analysis – YouTube](https://www.youtube.com/watch?v=zKZlXhU2MJQ)
