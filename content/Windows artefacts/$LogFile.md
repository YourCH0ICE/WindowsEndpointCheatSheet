---
title: 3. $LogFile
authors: 2026-09-11
---
---
### Definition 

 This file is stored in the MFT entry number 2 and every time there is a change in the NTFS Metadata, there is a transaction recorded in the <span style="color: #D96C6C;"> LogFile </span>. These transactions are recorded to be possible to redo or undo file system operations. Why would <span style="color: #D96C6C;"> LogFile </span>be important for investigation? Because the <span style="color: #D96C6C;"> LogFile </span>keeps record of all operations that occurred in the NTFS volume such as file creation, deletion, renaming, copy. 

---
### Path

In Windows, the NTFS transaction journal is stored in the hidden metadata file at the root of each NTFS volume:
```
C:\$LogFile 
```

### What information do $LogFile store?

$LogFile can store information about:

- Timeline Analysis 
- File Activity Analysis (Open, Close and Update) 
- Evidence of renamed and deleted files

To provide a clearer context, I've included a screenshot below:

![[Pasted image 20260911172532.png]]

### Important Forensic Point

The NTFS `$LogFile` records **filesystem metadata transactions**, not normal user activity directly. Its primary purpose is to maintain NTFS filesystem consistency and allow recovery after an unexpected shutdown or system crash.

A critical forensic limitation is that standard `$LogFile` records **do not contain their own event timestamps**. Instead, records are identified by a **Log Sequence Number (LSN)**, which can be used to determine the relative order of filesystem operations but should not be interpreted as the exact time when an action occurred.

Some forensic tools may display an estimated or extrapolated timestamp by correlating `$LogFile` records with other artifacts such as `$UsnJrnl` or `$MFT`. These timestamps should therefore be treated as **inferred timestamps**, not direct timestamps stored within `$LogFile`.

Another important consideration is that a single user-level action, such as creating, renaming, moving, or deleting a file, may generate **multiple low-level NTFS transactions**. Individual `$LogFile` records should therefore not be interpreted in isolation. Analysts should examine related records, Transaction IDs, LSN sequences, and Redo/Undo operations to reconstruct the complete filesystem transaction.

Because `$LogFile` is circular and older records are eventually overwritten, the absence of an expected operation **does not prove that the operation never occurred**.

---
### Analysis Tools

> [!info]- Click here
> For parsing `$LogFile`, you can use **LogFile**, which can parse the artifact into JSON or CSV files. After successful parsing, you can use **Timeline Explorer** or any other CSV/JSON editor capable of correctly displaying the file's contents for filtering and analysis.
> **[NTFS_Log_Tracker.exe]([https://download.ericzimmermanstools.com/net9/ShellBagsExplorer.zip](https://sites.google.com/site/forensicnote/ntfs-log-tracker))** – GUI tool for parsing **LogFile**.
> or you can use 
>[LogFileParser](https://github.com/jschicht/LogFileParser) – GUI tool for parsing **LogFile**. 
>

### Overall

The NTFS `$LogFile` is a transactional filesystem journal used by NTFS to maintain consistency and recover from interrupted operations.

From a forensic perspective, it is valuable because it can preserve traces of **recent file and directory activity**, including creation, deletion, renaming, moving, and metadata changes.

Its main strength is providing the **relative sequence and low-level details of NTFS operations** through LSNs, transaction records, and Redo/Undo data.

However, `$LogFile` should not be treated as a standalone timeline source. It is a **circular log**, older records are overwritten, and standard records do not contain reliable event timestamps.

For best results, analyze `$LogFile` together with `$MFT` and `$UsnJrnl` to reconstruct recent filesystem activity with higher confidence.

### Additional Resources 

> [!tip]- Click here
> - [TZWorks® $MFT and $Logfile Analysis (mala) Users Guide](https://tzworks.com/prototypes/mala/mala.users.guide.pdf?utm_source=chatgpt.com )

