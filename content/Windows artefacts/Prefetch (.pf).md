---
title: 4. Prefetch
authors: 2026-08-18
---
d---
### Defenition

<span style="color: #D96C6C;">Prefetch</span> files are created by the <span style="color: #D96C6C;">Prefetcher</span> – a Windows component that <span style="color: #FFD166;">tracks code and data loaded during application and OS startup</span>, storing this information in trace files to speed up subsequent launches. The maximum number of Prefetch files is <span style="color: #FFD166;">1,024</span>. Once this limit is reached, the <span style="color: #FFD166;">oldest entries are overwritten</span> by new ones.

The Prefetcher operates in two modes:

- **<span style="color: #D96C6C;">Boot Prefetching</span>** – tracks files and data accessed during <span style="color: #FFD166;">system startup</span>.
- **<span style="color: #D96C6C;">Application Prefetching</span>** – during the first <span style="color: #FFD166;">10 seconds after launch</span> (or until the process terminates, whichever comes first), the Prefetcher monitors all directories and files accessed by the running application. If the process terminates before 10 seconds have elapsed, the entry is <span style="color: #FFD166;">created immediately</span> rather than after the full 10 seconds.

Trace files carry the <span style="color: #D96C6C;">.pf</span> extension and follow a fixed <span style="color: #FFD166;">naming convention</span>: the name of the executable followed by a <span style="color: #FFD166;">hexadecimal hash of its path</span> – for example, <span style="color: #D96C6C;">MALWARE.EXE-082F38A9.pf</span>. As a result, the same executable can produce <span style="color: #FFD166;">multiple Prefetch files</span> if launched from different locations, each with a <span style="color: #FFD166;">distinct hash</span>.

![[Pasted image 20260823144323.png]]


---
### Path
The Prefetch files (.pf) is typically located at
```
C:\Windows\Prefetch
```
---
### What information does the Prefetch (.pf) store?
The Prefetch file can store information about

| Category | Fields |
| ------------------------------- | --------------------------------------------------------------------------------------------------------- |
| **Timestamps** | `Created on`, `Modified on`, `Last Accessed on` |
| **File Information** | `Executable Name`, `Hash`, `File Size (bytes)`, `Version` |
| **Execution Information** | `Run Count`, `Last Run` |
| **Volume Information** | `Volume Name`, `Volume Serial`, `Volume Created`, `Directories Count`, `File References Count` |
| **Directories Referenced** | `Full list of directories accessed during execution` |
| **Files Referenced** | `Full list of files accessed, spawned, or executed` |

---
#### Useful Information from the Prefetch (.pf)
The forensic value of Prefetch artifacts varies depending on the investigation. But based on our investigative experience, we have identified the most important ones 

⚪ **Run Count & Last Run**
> [!question]- Click here
> <span style="color: #D96C6C;">Run Count</span> indicates the <span style="color: #FFD166;">number of times the file was launched</span>. <span style="color: #D96C6C;">Last Run</span> provides the <span style="color: #FFD166;">exact timestamp of the most recent execution</span>. Together, these two fields help determine the <span style="color: #FFD166;">activity timeline</span> of the file on the system alongside existing artifacts.
> 
> ![[Pasted image 20260823150851.png]]

⚪ **Directories Referenced**
> [!question]- Click here
> <span style="color: #D96C6C;">Directories Referenced</span> indicates <span style="color: #FFD166;">where activity can be observed</span> and which directories the file under investigation has interacted with. This is valuable because it allows you to <span style="color: #FFD166;">immediately identify suspicious directory names</span> that require further investigation.
> 
> ![[Pasted image 20260823150817.png]]

⚪ **Files Referenced**
> [!question]- Click here 
> <span style="color: #D96C6C;">Files Referenced</span> is arguably the <span style="color:#FFD166;">most important parameter</span> – it clearly indicates which files were <span style="color: #FFD166;">created, edited, or otherwise interacted with</span> by the process under investigation. In some cases, this information can be obtained directly through Prefetch without any manual reconstruction. Additionally, files may be marked as <span style="color: #D96C6C;">Executable</span> – which further prompts investigation and tracking of the file.
> 
> ![[Pasted image 20260823150946.png]]

---
### Analysis Tools

> [!info]- Click here
> We use two analysis tools.
> 
> **[PECmd](https://github.com/EricZimmerman/PECmd)** – a tool developed by Eric Zimmerman, designed to analyze Prefetch files. It offers a sufficient number of parameters via <span style="color: #FFD166;">CLI</span>, yet remains extremely simple to use.
> 
> ![[Pasted image 20260823152905.png]]
> 
> **[KAPE](https://www.kroll.com/en/services/cyber/reactive-services/kroll-artifact-parser-and-extractor-kape)** – includes modules specifically designed to <span style="color: #FFD166;">parse Prefetch files</span>.
> 
> ![[Pasted image 20260823152612.png]]
> 
> Both options are excellent – the choice depends on the situation. If you have a <span style="color: #FFD166;">full artifact collection from a host</span>, automation is more practical than manual analysis, making <span style="color: #D96C6C;">KAPE</span> the better fit. If you have a <span style="color: #FFD166;">single Prefetch file</span> and nothing else, <span style="color: #D96C6C;">PECmd</span> is the way to go.
> 
> The choice is yours.
### Overall

> [!summary]- Overall
> In conclusion, <span style="color: #D96C6C;">Prefetch</span> is an <span style="color: #FFD166;">extremely powerful source of evidence</span> regarding <span style="color: #FFD166;">process execution</span> and <span style="color: #FFD166;">file/directory interactions</span>. In practice, it consistently contributes to investigations – <span style="color: #FFD166;">rarely leaving you empty-handed</span>.

### Additional Resources

> [!tip]- Additional Resources
> - [Prefetcher – Wikipedia](https://en.wikipedia.org/wiki/Prefetcher)
> - [Prefetch Forensics – SANS ISC](https://isc.sans.edu/diary/29168)
> - [Prefetch Analysis – YouTube](https://www.youtube.com/watch?v=f4RAtR_3zcs)