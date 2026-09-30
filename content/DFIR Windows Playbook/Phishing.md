---
title: 1. Phishing
authors: 2026-08-18
ID: T1566
Tactic: Initial Access
---
---
### Definition 
Adversaries may send phishing messages to gain access to victim systems. All forms of phishing are electronically delivered social engineering. Phishing can be targeted, known as spearphishing. In spearphishing, a specific individual, company, or industry will be targeted by the adversary. More generally, adversaries can conduct non-targeted phishing, such as in mass malware spam campaigns.

Adversaries may send victims emails containing malicious attachments or links, typically to execute malicious code on victim systems. Phishing may also be conducted via third-party services, like social media platforms. Phishing may also involve social engineering techniques, such as posing as a trusted source, as well as evasive techniques such as removing or manipulating emails or metadata/headers from compromised accounts being abused to send messages (e.g., [Email Hiding Rules](https://attack.mitre.org/techniques/T1564/008)).[[1]](https://www.microsoft.com/en-us/security/blog/2022/09/22/malicious-oauth-applications-used-to-compromise-email-servers-and-spread-spam/)[[2]](https://unit42.paloaltonetworks.com/examining-vba-initiated-infostealer-campaign/) Another way to accomplish this is by [Email Spoofing](https://attack.mitre.org/techniques/T1684/002)[[3]](https://www.proofpoint.com/us/threat-reference/email-spoofing) the identity of the sender, which can be used to fool both the human recipient as well as automated security tools,[[4]](https://blog.cyberproof.com/blog/double-bounced-attacks-with-email-spoofing-2022-trends) or by including the intended target as a party to an existing email thread that includes malicious files or links (i.e., "thread hijacking").[[5]](https://krebsonsecurity.com/2024/03/thread-hijacking-phishes-that-prey-on-your-curiosity/)

Victims may also receive phishing messages that instruct them to call a phone number where they are directed to visit a malicious URL, download malware,[[6]](https://blog.sygnia.co/luna-moth-false-subscription-scams)[[7]](https://www.cisa.gov/uscert/ncas/alerts/aa23-025a) or install adversary-accessible remote management tools onto their computer (i.e., [User Execution](https://attack.mitre.org/techniques/T1204)).[[8]](https://unit42.paloaltonetworks.com/luna-moth-callback-phishing/) More info: [MITRE_ ATT&CK](https://attack.mitre.org/techniques/T1566)

---
### Questions for the Investigator  

1. С какого мейлового адреса пришел данный мейл? 
	1. Какая репутация у домена, с которого был отправлен мейл ? 
		1. [MXtoolbox](https://mxtoolbox.com/SuperTool.aspx) 
		2.  [EML analyzer](https://analyzer.sublime.security/) - EML Analysis tool
		3. [Kernel OST Viewer](https://www.nucleustechnologies.com/page/ostviewer.html?gad_source=1&gad_campaignid=24033507733&gbraid=0AAAAAD8EdVdFZcyKAM6zlIAHTKFtWARfd&gclid=Cj0KCQjwk5nVBhDiARIsAHNGqacDc_Ugm2wt9lsT7Y6uRIauvuqBxvT71hB9FVFUH37R_lbQqUueQKIaAqFgEALw_wcB) - OST Viewer
	2. Сколько сотрудников получили данный мейл ? 
2. Почта с которой пришел мейл является внутренней почтой компании? 
	1. Шаги по ремедиации 
3. Когда данный мейл был доставлен? 
4. Что из себя представляет мейл ? 
	1. Фишинговое письмо имеет прикрепленный файл?
		1. Да, пользователь его запустил [[User Execution]]
	2. Фишинговое письмо имеет вредоносную ссылку, которая используется для кражи  данных учетной записи? 
		1. Открывал ли его пользователь? 
			1. В случае если да, то Шаги по ремедиации 