---
title: DFIR Windows Investigation Map
description: Artifact-driven investigation workflow for Windows endpoint analysis.
tags:
  - DFIR
  - Windows
  - Investigation
  - Playbook
---

# DFIR Windows Investigation Map

> [!info] Goal
> Start with what you already know, prove it with Windows artifacts, determine what happened before and after it, and use every confirmed fact as the next pivot.
>
> This page is intentionally high-level. Detailed artifact analysis belongs in dedicated playbook pages.

---

# Start Here

## What do you know?

Choose the strongest known starting point:

- Suspicious executable or DLL
- Suspicious process
- PowerShell / CMD / script execution
- Downloaded file
- URL / domain / IP address
- Network connection
- Registry modification
- Scheduled Task
- Windows Service
- User / account activity
- Logon event
- Email / attachment
- Persistence artifact
- EDR / AV detection
- Unknown suspicious activity

Then begin the investigation loop.

---

# Universal Investigation Loop

## 1. Identify the Object

First establish exactly what you are investigating.

Ask:

- What is it?
- Where is it?
- When was it first observed?
- Which host is involved?
- Which user is involved?
- What is the strongest known evidence?
- Is the object itself suspicious, or only its context?

Examples:

- `powershell.exe`
- `C:\Users\user\Downloads\update.exe`
- `HKCU\...\Run`
- Scheduled Task `Updater`
- Connection to `example.com`
- Logon from another workstation

---

## 2. Prove the Observation

Do not assume that an alert or file presence proves execution or compromise.

Ask:

- Can I prove the file existed?
- Can I prove it executed?
- Can I prove which user executed it?
- Can I prove when it executed?
- Can I prove which process launched it?
- Can I prove it made a network connection?
- Can I prove it created persistence?

Use more than one artifact whenever possible.

### Evidence Principle

**Observation → Artifact → Corroboration → Conclusion**

Example:

```text
Suspicious EXE found
        ↓
Prefetch exists
        ↓
4688 / Sysmon / EDR confirms process creation
        ↓
Execution confirmed
```

---

## 3. Determine Origin

Ask where the object came from.

Possible origins:

- Browser download
- Email attachment
- Archive extraction
- PowerShell download
- BITS
- curl / wget
- certutil
- SMB share
- RDP session
- USB device
- Software deployment
- Administrative tool
- Another process
- Unknown

Questions:

- Was the file downloaded?
- Was it extracted from an archive?
- Was it copied from another host?
- Was it dropped by another process?
- Was it created by a script?
- Was it delivered by email?

### Useful Artifact Categories

- Zone.Identifier
- Browser history / downloads
- Email artifacts
- PowerShell logs
- Process creation logs
- File-system timestamps
- LNK files
- Recent files
- EDR telemetry

---

## 4. Determine Execution

If the object is executable, scriptable, or launchable, determine whether it actually executed.

Ask:

- Was it executed?
- How many times?
- By which user?
- From which path?
- What launched it?
- Was execution interactive or automated?
- Was it executed locally or remotely?

### Useful Artifact Categories

- Prefetch
- Event ID 4688
- Sysmon Event ID 1
- EDR / XDR process telemetry
- UserAssist
- BAM / DAM
- Amcache
- SRUM
- PowerShell logs
- Scheduled Tasks
- Services

> [!warning]
> Not every artifact independently proves execution.
> Always understand what an artifact can and cannot prove before using it as evidence.

---

## 5. Determine Execution Context

Once execution is confirmed, reconstruct the process context.

Ask:

- What was the parent process?
- What was the command line?
- Which user context was used?
- What integrity level was used?
- Was elevation involved?
- Was the process started by a service?
- Was it started by Task Scheduler?
- Was it launched by PowerShell, CMD, WScript, MSHTA, Rundll32, Regsvr32, or another LOLBin?

### Build the Process Chain

```text
Parent
  ↓
Process
  ↓
Child process
  ↓
Next child
```

Do not investigate a suspicious process in isolation.

---

## 6. Determine What It Did

For every confirmed process or script, ask what changed because it executed.

Check for:

- Child processes
- Files created
- Files modified
- Files deleted
- Registry changes
- Scheduled Tasks
- Services
- Account changes
- Credential access
- Network connections
- DNS requests
- Remote connections
- Security control changes
- Persistence
- Discovery commands
- Lateral movement
- Data collection
- Exfiltration

Every confirmed action becomes a new pivot.

---

# Pivot Rule

> [!tip]
> Every confirmed artifact should generate the next investigation question.

Example:

```text
PowerShell executed
        ↓
What command was executed?
        ↓
PowerShell downloaded payload.exe
        ↓
Where was payload.exe written?
        ↓
Was payload.exe executed?
        ↓
What launched it?
        ↓
What did payload.exe create?
        ↓
Did it create persistence?
        ↓
Did it communicate externally?
        ↓
What happened next?
```

---

# Common Starting Points

## A. I Have an EXE / DLL

Start with:

1. What is the file?
2. Where did it come from?
3. Did it execute?
4. Who executed it?
5. What launched it?
6. What did it create or modify?
7. Did it connect to the network?
8. Did it create persistence?
9. What happened next?

Useful artifact categories:

- File metadata
- Hash / signature
- Zone.Identifier
- Prefetch
- Amcache
- UserAssist
- BAM / DAM
- 4688
- Sysmon
- EDR telemetry
- SRUM
- Browser artifacts
- LNK files

---

## B. I Have PowerShell / CMD / Script Activity

Start with:

1. What command or script executed?
2. Who executed it?
3. What launched the interpreter?
4. Was content encoded or obfuscated?
5. Did it download anything?
6. Did it create or modify files?
7. Did it launch another process?
8. Did it modify registry or persistence?
9. Did it connect externally?
10. What was the next process in the chain?

Useful artifact categories:

- PowerShell 4103 / 4104
- PowerShell operational logs
- 4688
- Sysmon
- EDR telemetry
- ConsoleHost_history.txt
- Prefetch
- DNS / network telemetry
- File-system artifacts

---

## C. I Have a Suspicious Process

Start with:

1. What launched it?
2. What was the command line?
3. Which user executed it?
4. From which path?
5. Is the binary legitimate?
6. What children did it create?
7. What files did it touch?
8. What registry keys did it modify?
9. What network connections did it make?
10. Did it establish persistence?

---

## D. I Have a Downloaded File

Start with:

1. Where did it come from?
2. Which application downloaded it?
3. Which user downloaded it?
4. When was it downloaded?
5. Was it opened?
6. Was it executed?
7. What happened after execution?
8. Did it create another payload?

Useful artifact categories:

- Zone.Identifier
- Browser download history
- Browser history
- WebCache
- Email artifacts
- PowerShell logs
- Prefetch
- UserAssist
- EDR telemetry

---

## E. I Have a Network IOC

Start with:

1. Which process connected?
2. Which host connected?
3. Which user context was active?
4. When did communication start?
5. Was DNS resolution observed?
6. Was the connection repeated?
7. Was data transferred?
8. Which executable created the connection?
9. What happened before the connection?
10. What happened after it?

Useful artifact categories:

- EDR network telemetry
- DNS logs
- Firewall logs
- Proxy logs
- SRUM
- Sysmon
- Process creation telemetry

---

## F. I Have a Persistence Artifact

Start with:

1. What created it?
2. When was it created?
3. Which executable or script does it reference?
4. Which user context does it run under?
5. Has the referenced payload executed?
6. What happens when persistence triggers?
7. Is the same persistence present elsewhere?

Useful artifact categories:

- Registry
- Scheduled Tasks
- Services
- Startup folders
- WMI
- Run / RunOnce
- PowerShell profiles
- Logon scripts
- LNK files
- Process telemetry

See also: [[Persistence]]

---

## G. I Have an Email / Attachment

Start with:

1. Who sent it?
2. Who received it?
3. Was the attachment opened?
4. Was a link clicked?
5. Was a file downloaded?
6. Did Office or the browser launch a child process?
7. Were credentials entered?
8. What happened after user interaction?

See also: [[Phishing]]

---

# Artifact Question Matrix

| Question | Artifact Categories |
|---|---|
| Did this file exist? | MFT, Amcache, filesystem metadata, EDR |
| Did it execute? | Prefetch, 4688, Sysmon 1, EDR, UserAssist, BAM/DAM |
| Who executed it? | 4688, Sysmon, EDR, UserAssist, logon context |
| What launched it? | Process tree, 4688, Sysmon, EDR |
| Where did it come from? | Zone.Identifier, browser artifacts, email, PowerShell, LNK |
| What did it create? | MFT, USN Journal, EDR, Sysmon |
| What did it modify? | Registry, filesystem, EDR, Sysmon |
| Did it persist? | Run keys, Scheduled Tasks, Services, WMI, Startup |
| Did it connect out? | EDR, Sysmon, SRUM, DNS, firewall, proxy |
| Did it run remotely? | RDP, SMB, WinRM, WMI, PsExec, logon events |
| Did it access credentials? | LSASS-related telemetry, Security logs, EDR |
| What happened next? | Timeline correlation across all available artifacts |

---

# Build the Timeline Continuously

Do not wait until the end of the investigation.

For every confirmed event, record:

| Time | Host | User | Process / Artifact | Action | Evidence |
|---|---|---|---|---|---|
| | | | | | |

The timeline should answer:

- What happened first?
- What caused the next event?
- Which events are confirmed?
- Which events are inferred?
- Where are the gaps?
- What artifact could fill each gap?

---

# Confidence

Label important findings internally as:

- **Confirmed** — directly supported by reliable evidence
- **Supported** — multiple artifacts strongly support the conclusion
- **Possible** — plausible but not sufficiently proven
- **Unknown** — evidence is currently insufficient

Avoid turning artifact presence into stronger claims than the artifact supports.

---

# Investigation Loop Summary

```text
START WITH WHAT YOU KNOW
        ↓
DEFINE THE QUESTION
        ↓
SELECT THE ARTIFACTS THAT CAN ANSWER IT
        ↓
PROVE OR REJECT THE HYPOTHESIS
        ↓
IDENTIFY WHAT HAPPENED BEFORE
        ↓
IDENTIFY WHAT HAPPENED AFTER
        ↓
PIVOT TO THE NEXT OBJECT
        ↓
UPDATE THE TIMELINE
        ↓
REPEAT
```

> [!quote] Core Principle
> Do not follow a fixed incident checklist. Follow the evidence.
> Each confirmed fact should tell you what to investigate next.
