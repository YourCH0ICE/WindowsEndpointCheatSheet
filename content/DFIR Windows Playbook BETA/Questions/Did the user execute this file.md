
**To answer this question, check out the following artifacts:**

**Filesystem Artifacts** 
- [[Prefetch (.pf)]]
- [[Amcache]] 
- [[MFT]]

**Registry Artifacts**  
- `Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist`
- `Software\Microsoft\Windows\CurrentVersion\Search\RecentApps`
- `SYSTEM\CurrentControlSet\Services\Bam\State\UserSettings\<SID>`

**Windows Event Logs**
- **Security.evtx** — [Event ID 4688](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventID=4688)
- **Sysmon** — [Event ID 1](https://www.ultimatewindowssecurity.com/securitylog/encyclopedia/event.aspx?eventid=90001)

**Windows Defender Logs**
- Detection History Files:`C:\ProgramData\Microsoft\Windows Defender\Scans\History\Service\DetectionHistory\`
- **Offline Scan Logs:** `C:\Windows\Microsoft Antimalware\Support\`