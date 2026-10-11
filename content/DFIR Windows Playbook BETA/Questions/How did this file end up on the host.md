**To answer this question, check out the following artifacts:** 

**Filesystem Artifacts** 
- [[MFT]]

**Browser Artifacts:** 

| Browser                       | Browser History                                                               |
| ----------------------------- | ----------------------------------------------------------------------------- |
| **Google Chrome**             | `%LOCALAPPDATA%\Google\Chrome\User Data\Default\History`                      |
| Chrome, другой профиль        | `%LOCALAPPDATA%\Google\Chrome\User Data\Profile 1\History`                    |
| **Microsoft Edge (Chromium)** | `%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\History`                     |
| Edge, другой профиль          | `%LOCALAPPDATA%\Microsoft\Edge\User Data\Profile 1\History`                   |
| **Mozilla Firefox**           | `%APPDATA%\Mozilla\Firefox\Profiles\<PROFILE>\places.sqlite`                  |
| **Brave**                     | `%LOCALAPPDATA%\BraveSoftware\Brave-Browser\User Data\Default\History`        |
| **Opera**                     | `%APPDATA%\Opera Software\Opera Stable\History`                               |
| **Opera GX**                  | `%APPDATA%\Opera Software\Opera GX Stable\History`                            |
| **Vivaldi**                   | `%LOCALAPPDATA%\Vivaldi\User Data\Default\History`                            |
| **Chromium**                  | `%LOCALAPPDATA%\Chromium\User Data\Default\History`                           |
| **Yandex Browser**            | `%LOCALAPPDATA%\Yandex\YandexBrowser\User Data\Default\History`               |
| **Tor Browser**               | `<Tor Browser>\Browser\TorBrowser\Data\Browser\profile.default\places.sqlite` |

**PowerShell Logs Artifacts:**
- ConsoleHost_history.txt: `C:\Users\<user_name>\AppData\Microsoft\Windows\PowerShell\PSReadLine\` 
- Microsoft-Windows-PowerShell%4Operational.evtx analysis
- Sysmon logs analysis

**Copying from External Devices**

To verify this hypothesis, we need to analyze the correlation between events. 
**To perform a correlation, follow these steps** 
