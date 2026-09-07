---
title: 4. .LNK Files
authors: 2026-08-18
---
---
### Defenition

A <span style="color: #D96C6C;">.LNK file</span> is created <span style="color: #FFD166;">each time a user opens a file</span>. These files can be created <span style="color: #FFD166;">automatically by the system</span> or manually at the user's request, and they are used to quickly access files and programs without having to search for the original file.

It should be noted that the creation of a <span style="color: #D96C6C;">.LNK file</span> depends directly on the <span style="color: #FFD166;">type of file</span> the user is interacting with, specifically:

- <span style="color: #D96C6C;">.LNK files</span> in the <span style="color: #D96C6C;">Recent Items</span> folder are created by the Windows system primarily when a user opens a file to work on it (by double-clicking, via the context menu, or through the Open dialog in a program). In doing so, the system calls the <span style="color: #D96C6C;">SHAddToRecentDocs</span> API. For non-executable files (<span style="color: #D96C6C;">.txt</span>, <span style="color: #D96C6C;">.docx</span>, <span style="color: #D96C6C;">.zip</span>, etc.), this works reliably.

- For executable files (<span style="color: #D96C6C;">.exe</span>), Windows behaves differently by default: the system <span style="color: #FFD166;">does not add the .exe files themselves to Recent Items</span> by default, to avoid cluttering the list. Therefore, a <span style="color: #D96C6C;">.LNK file</span> for an <span style="color: #D96C6C;">.exe</span> in this folder is either <span style="color: #FFD166;">not created at all</span>, or is created only if the program developer explicitly called the corresponding API.

---
### Path
The .LNK is typically located at
```
%APPDATA%\Microsoft\Windows\Recent\

%AppData%\Microsoft\Office\Recent\

%SystemDrive%:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp

%AppData%\Microsoft\Windows\Start Menu\Programs\Startup
```

---
### What information does the LNK store?
| Category                               | Fields                                                                                                        |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| Source File Information                | Source File Path, Source Created, Source Modified, Source Accessed                                            |
| Header – Target Timestamps             | Target Created, Target Modified, Target Accessed                                                              |
| Header – File Properties               | File Size (bytes), File Attributes, Icon Index, Show Window                                                   |
| Header – Flags                         | Flags                                                                                                         |
| Path Information                       | Relative Path, Working Directory                                                                              |
| Link Information – Flags               | Link Flags                                                                                                    |
| Link Information – Volume              | Drive Type, Serial Number, Volume Label, Local Path                                                           |
| Target ID Information                  | Absolute Path, File Name, Short Name, Modified                                                                |
| Target ID – Extension Block (Beef0004) | Long Name, Created, Last Access, MFT Entry/Sequence #                                                         |
| Tracker Database Block                 | Machine ID, MAC Address, MAC Vendor, Creation, Volume Droid, Volume Droid Birth, File Droid, File Droid Birth |
| Property Store Block                   | Volume ID (GUID)                                                                                              |

---

### Usefull Information from the MFT

In our experience, LNK files are an extremely useful artifact in an investigation, as they contain a sufficient number of information fields that, in one way or another, can indicate the actual activity of the file to which they link. Not all fields are informative, but we will discuss below the most useful fields from a DFIR perspective.
##### ⚪ Source created and Target created Timestamps

> [!question]- Click here
> 
> From a timestamp perspective, the most useful ones are the <span style="color: #D96C6C;">creation time of the source</span> (the LNK file itself) and the <span style="color: #D96C6C;">creation time of the target file</span>.
> 
> The <span style="color: #D96C6C;">source creation time</span> can <span style="color: #FFD166;">directly indicate when the target file was launched</span>. For example, if we are analyzing the execution time of <span style="color: #D96C6C;">malware.ps1</span> and have no access to <span style="color: #D96C6C;">Prefetch</span>, <span style="color: #D96C6C;">MFT</span>, <span style="color: #D96C6C;">Journal ($J)</span>, <span style="color: #D96C6C;">Amcache</span>, or other artifacts – the creation time of the <span style="color: #D96C6C;">.LNK file</span> in <span style="color: #D96C6C;">Recent Items</span> can serve as a reliable indicator of <span style="color: #FFD166;">when the file was first interacted with</span>.
> 
> ![[Pasted image 20260907120431.png]]
> 
>  The <span style="color: #D96C6C;">target file creation time</span> may indicate <span style="color: #FFD166;">when the original file was created</span> on the system. This is especially valuable in situations where logs or other artifacts are <strong>corrupted or unavailable</strong> – allowing the investigator to <span style="color: #FFD166;">establish a lower bound for the file's existence</span> on the machine, which is critical for <span style="color: #FFD166;">scoping the incident and understanding the timeline of malicious activity</span>.
>  
>  ![[Pasted image 20260907120514.png]]
##### ⚪Modified and Access Timestamps

> [!question]- Click here
> 
> Unlike the timestamps discussed earlier, <span style="color: #D96C6C;">Modified</span> and <span style="color: #D96C6C;">Accessed</span> timestamps behave differently in terms of <span style="color: #FFD166;">how and when they are triggered</span>, which is why they are worth addressing separately.
> 
> **Source Modified**
> 
> The <span style="color: #D96C6C;">Source Modified</span> timestamp is updated <span style="color: #FFD166;">each time the target file is opened</span> – meaning it reflects the <span style="color: #FFD166;">most recent interaction with the target file</span>, as recorded by the MFT. This makes it a particularly valuable indicator: if the <span style="color: #D96C6C;">.LNK file was modified</span>, it can be interpreted as indirect evidence that the <span style="color: #FFD166;">target file was executed at that point in time</span>. In the absence of <span style="color: #D96C6C;">Prefetch</span>, <span style="color: #D96C6C;">Amcache</span>, or other execution artifacts, this timestamp serves as a <strong>rough but meaningful indicator of last execution</strong>. However, as with any single artifact, it <span style="color: #FFD166;">requires corroboration from additional sources</span> before a definitive conclusion can be drawn.
> 
> **Source Accessed**
> 
> The <span style="color: #D96C6C;">Source Accessed</span> timestamp reflects <span style="color: #FFD166;">when the .LNK file itself was last read or accessed</span>. However, this timestamp is considered <strong>less reliable</strong> in practice: on modern Windows systems, Last Access tracking is <span style="color: #FFD166;">disabled by default</span> via <span style="color: #D96C6C;">NtfsDisableLastAccessUpdate</span>, which means this value may not be updated at all, significantly limiting its forensic value.
> 
> **Target Modified**
> 
> The <span style="color: #D96C6C;">Target Modified</span> timestamp indicates <span style="color: #FFD166;">when the target file was last changed</span>. It is worth noting, however, that in NTFS this value can be updated <span style="color: #FFD166;">without any actual change to the file's contents</span>, which should be taken into account when drawing conclusions based solely on this timestamp.
> 
> **Target Accessed**
> 
> The <span style="color: #D96C6C;">Target Accessed</span> timestamp reflects <span style="color: #FFD166;">when the target file was last accessed</span>. Similarly to <span style="color: #D96C6C;">Source Accessed</span>, this timestamp is subject to the same limitation: on modern Windows systems, Last Access tracking is <span style="color: #FFD166;">disabled by default</span>, which means the value stored in the <span style="color: #D96C6C;">.LNK file</span> may represent the state <span style="color: #FFD166;">at the time the shortcut was created</span> rather than reflecting any subsequent access, further <span style="color: #FFD166;">reducing its reliability as a standalone forensic indicator</span>.
> 
> ![[Pasted image 20260907131045.png]]
##### ⚪ Command Line

> [!question]- Click here
> 
> <span style="color: #D96C6C;">Command-line arguments</span> are an extremely powerful indicator when analyzing <span style="color: #D96C6C;">.LNK files</span>. In the context of attacker activity, a malicious <span style="color: #D96C6C;">.LNK file</span> may contain a <span style="color: #FFD166;">hidden command embedded in its properties</span> – one that, upon a successful click by an unsuspecting user, can <span style="color: #FFD166;">trigger a hidden payload, establish a connection to a C2 server, or download additional malicious components</span>.
> 
> This technique is effective precisely because <span style="color: #FFD166;">ordinary users do not inspect shortcut properties</span> before interacting with them, making <span style="color: #D96C6C;">.LNK files</span> a convenient vector for <span style="color: #FFD166;">concealing malicious logic</span> behind a seemingly legitimate file.
> 
> It is also worth noting that a <span style="color: #D96C6C;">.LNK file</span> does not necessarily execute a command directly – it may instead <span style="color: #FFD166;">reference an external file to retrieve a payload</span>, acting as a first-stage loader. The specific implementation depends entirely on the attacker's approach.
> 
> ![[Pasted image 20260907122628.png]]
> 
> Regardless of the method, <span style="color: #D96C6C;">command-line arguments</span> remain a <strong>key forensic indicator</strong>: their presence, structure, and content can help determine <span style="color: #FFD166;">whether a given .LNK file is malicious</span> and reveal the <span style="color: #FFD166;">nature of the intended action</span>.
##### ⚪ File Size

> [!question]- Click here
> 
> Another artifact worth noting is <span style="color: #D96C6C;">File Size</span>. While it is not a primary forensic indicator, it can still provide <span style="color: #FFD166;">valuable context during analysis</span>. It is important to understand that the value stored in the <span style="color: #D96C6C;">.LNK file</span> reflects the <span style="color: #FFD166;">size of the target file at the time the shortcut was created</span> – meaning it may not match the file's current size, which in itself can be a <span style="color: #FFD166;">sign of tampering or modification</span>.
> 
> Based on the recorded size, an investigator can <span style="color: #FFD166;">draw indirect conclusions about the nature of the file's contents</span>. For example, an <span style="color: #D96C6C;">abnormally large size</span> for a file with a benign extension such as <span style="color: #D96C6C;">.txt</span> or <span style="color: #D96C6C;">.pdf</span> may suggest the presence of an <span style="color: #FFD166;">embedded payload</span>, while an <span style="color: #D96C6C;">unexpectedly small size</span> may indicate that the file acts merely as a <span style="color: #FFD166;">first-stage loader or pointer</span> to external malicious components.
> 
> ![[Pasted image 20260907123919.png]]
> 
> In cases where the <span style="color: #D96C6C;">MFT is unavailable, corrupted, or has been deliberately wiped</span>, the <span style="color: #D96C6C;">File Size</span> value stored within the <span style="color: #D96C6C;">.LNK file</span> may serve as a <strong>partial substitute</strong>, helping to <span style="color: #FFD166;">reconstruct the state of the target file at the time of interaction</span>.
##### ⚪ Identifying Potential Indicators of Timestomping technique Based on .LNK

> [!question]- Click here
> 
> When a file is opened via the Windows Shell, the system automatically creates a <span style="color: #D96C6C;">.LNK file</span> that records the <span style="color: #D96C6C;">Target Created</span> timestamp – the creation time of the target file <span style="color: #FFD166;">at the moment of the first Shell interaction</span>. This makes the .LNK file an <span style="color: #FFD166;">independent source of timestamp information</span>, entirely separate from the <span style="color: #D96C6C;">$MFT</span>. 
> 
> If an attacker applies <span style="color: #D96C6C;">timestomping</span> after that interaction, a discrepancy arises: the <span style="color: #D96C6C;">$MFT</span> reflects the <span style="color: #FFD166;">forged time</span>, while the <span style="color: #D96C6C;">.LNK</span> still holds the <span style="color: #FFD166;">original value</span>. This inconsistency serves as a <strong>preliminary indicator of possible timestamp manipulation</strong>, requiring further corroboration from other artifacts.
> 
> Click here to get more info: will be soon

---
### Analysis Tools

> [!info]- Click here
> 
> Two tools are worth highlighting for analyzing <span style="color: #D96C6C;">.LNK files</span>:
> 
> **[LECmd](https://github.com/EricZimmerman/LECmd)** – a <span style="color: #FFD166;">CLI tool</span> by Eric Zimmerman that <span style="color: #FFD166;">automatically parses .LNK fields</span> and displays the output directly on the screen.
> 
> ![[Pasted image 20260907132438.png]]
> 
> Example command: `.\LECmd.exe -f C:\Users\<username>\Desktop\Sample.txt.lnk`
> 
> **[KAPE + LECmd](https://www.kroll.com/en/services/cyber/reactive-services/kroll-artifact-parser-and-extractor-kape)** – a <span style="color: #FFD166;">KAPE module</span> that <span style="color: #FFD166;">automates .LNK parsing</span> and outputs results in a format convenient for further analysis; requires <span style="color: #D96C6C;">KAPE</span> to be installed.
> 
> ![[Pasted image 20260907132509.png]]
### Overall

> [!summary]- Click here
> 
> <span style="color: #D96C6C;">LNK files</span> are among the most underestimated artifacts in <span style="color: #D96C6C;">DFIR</span>. A single <span style="color: #D96C6C;">.LNK file</span> can reveal the <span style="color: #FFD166;">first interaction time</span> with a target file, its <span style="color: #FFD166;">creation timestamp at the moment of Shell execution</span>, the <span style="color: #FFD166;">machine it originated on</span>, and <span style="color: #FFD166;">embedded command-line arguments</span> – making it a reliable supplementary source across a wide range of investigations.
> 
> The real value of <span style="color: #D96C6C;">LNK files</span> lies in their <strong>independence</strong>. Recorded <span style="color: #FFD166;">before any potential manipulation occurs</span>, they can expose discrepancies introduced by <span style="color: #D96C6C;">timestomping</span>, indirectly confirm <span style="color: #FFD166;">file execution</span> in the absence of <span style="color: #D96C6C;">Prefetch</span> or <span style="color: #D96C6C;">Amcache</span>, and reveal <span style="color: #FFD166;">malicious payloads hidden within shortcut properties</span>. Combined, these fields allow an investigator to <span style="color: #FFD166;">reconstruct a meaningful picture of file activity</span> even when primary artifacts are <strong>unavailable or have been tampered with</strong>.
> 
### Additonal Resources

> [!tip]- Click here
> 
> - [Using LNK Files in Cyberattacks – Acronis](https://www.acronis.com/en/tru/posts/using-lnk-files-in-cyberattacks/)
> - [LNK: Analysing the Windows Shortcut Files – MeetCyber](https://meetcyber.net/lnk-analysing-the-windows-shortcut-files-2bb8cd9b200d)
> - [LNK File Forensics – YouTube](https://www.youtube.com/watch?v=wu4-nREmzGM)
