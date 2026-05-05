# Claude for Chrome · Autopilot Setup Script
## Hands-off setup for the BSW Growth Agent demo

> Paste the prompt below into Claude for Chrome (claude.com/chrome). Stay nearby — you'll need to enter passwords, accept OAuth consent screens, and click through 2FA when it pauses. Total time: ~10 minutes hands-on, ~5 minutes total of *your* attention.

---

## Pre-flight (1 minute · do this first manually)

1. Make sure you're signed into Chrome with your `sophia@agenticarchitect.ai` Google account
2. Open this file in a tab so Claude for Chrome can read the prompt
3. Have your phone ready for 2FA codes
4. Open `/home/sophia-stein/bsw/handouts/voice-md-template.md` and `/home/sophia-stein/bsw/handouts/icp-md-template.md` — Claude for Chrome will copy from these into Google Drive

---

## The autopilot prompt · copy everything between the `===` lines

```
=== AUTOPILOT PROMPT FOR CLAUDE FOR CHROME · BEGIN ===

You are setting up the BSW Growth Agent demo for Sophia Stein, who is presenting at Boulder Startup Week 2026 on Thursday May 7. We are using the FREE-TIER path: Groq for the LLM (no credit card needed), Jina Reader for web extraction (no signup at all), n8n.cloud for the workflow runtime (14-day free trial). Walk through these tasks in order. Pause for me only when you need me to enter a password, accept an OAuth consent screen, accept a Terms of Service, or enter a 2FA code. Otherwise proceed autonomously.

CRITICAL: every API key or important value you copy, paste it into a new tab as plain text in this format:

  ANTHROPIC_API_KEY=sk-ant-...  (or skip)
  GROQ_API_KEY=gsk_...
  FIRECRAWL_API_KEY=fc-...      (optional · free tier)
  N8N_INSTANCE_URL=https://...n8n.cloud
  GOOGLE_SHEET_ID=1AbC...XyZ
  VOICE_MD_FILE_ID=...
  ICP_MD_FILE_ID=...

I'll copy them from that tab into n8n manually after you finish. Do NOT paste them into chat or email — keep them in the temp tab only.

═══════════════════════════════════════════════════
TASK 1 · GROQ FREE TIER (LLM provider)
═══════════════════════════════════════════════════

Open https://console.groq.com in a new tab.
- If sign-in needed, use my sophia@agenticarchitect.ai Google account.
- Once signed in, navigate to API Keys.
- Create a new API key named "bsw-growth-agent".
- Copy the key (starts with "gsk_") to the temp credentials tab.
- Confirm: Groq's free tier should not ask for a credit card. If it does, pause and tell me — we may need to use a different provider.

═══════════════════════════════════════════════════
TASK 2 · n8n.CLOUD (workflow runtime)
═══════════════════════════════════════════════════

Open https://n8n.cloud in a new tab.
- Sign up for the 14-day free trial (no credit card required).
- Use my sophia@agenticarchitect.ai Google account if SSO is offered.
- Once inside, note the workflow URL (will look like https://[name].app.n8n.cloud) and add it to the temp credentials tab.
- DO NOT import the workflow yet · we'll do that after creating the Google assets so we can paste IDs in.

═══════════════════════════════════════════════════
TASK 3 · GOOGLE SHEET (config storage)
═══════════════════════════════════════════════════

Open https://docs.google.com/spreadsheets/u/0/create in a new tab.

Rename the spreadsheet to: BSW Discovery Engine

Create three tabs by right-clicking the bottom tab area · Add Sheet:
  Tab 1: ICP
  Tab 2: Sent
  Tab 3: Runs

Tab 1 (ICP) · Row 1 headers:
  A1: icp_description
  B1: signal_keywords

Tab 1 (ICP) · Row 2 content (paste exactly):
  A2: Early-stage SaaS founders pre-PMF or just-past-PMF · technical-leaning · running outbound or research themselves · paying for Lindy/Zapier/Clay or hiring SDRs · usually Boulder/Denver/Bay Area but geography is not a hard filter
  B2: n8n cost,Lindy credits surprise,hired SDR,replaced our outbound team,Sonnet 4.6 cost,Apollo.io alternative,Smartlead vs Instantly,Clay too expensive,founder-led sales,prospecting for hours,Anthropic bill,running out of credits,n8n self-host,Make.com pricing,LangGraph too complex,agent that drafts emails

Tab 2 (Sent) · Row 1 headers:
  A1: date
  B1: person
  C1: signal_type
  D1: source_url
  E1: score
  F1: draft_subject
  G1: status

(Tab 2 stays empty under headers · agent will append rows.)

Tab 3 (Runs) · Row 1 headers:
  A1: date
  B1: leads_found
  C1: qualified
  D1: drafts
  E1: errors
  F1: notes

(Tab 3 stays empty under headers · agent will append rows.)

Once done, copy the spreadsheet ID from the URL (the long string between /d/ and /edit) into the temp credentials tab.

═══════════════════════════════════════════════════
TASK 4 · GOOGLE DRIVE FOLDER + voice.md
═══════════════════════════════════════════════════

Open https://drive.google.com in a new tab.
- Create a new folder called "agentic-architect" (root of My Drive).
- Inside that folder, create a new Google Doc called "voice.md"
- Open the local file at /home/sophia-stein/bsw/handouts/voice-md-template.md and copy its entire contents into the voice.md Google Doc you just created.
- Right-click voice.md → Share → Get link → copy. Extract the file ID (between /d/ and /view) and add to the temp credentials tab.

═══════════════════════════════════════════════════
TASK 5 · GOOGLE DRIVE icp.md
═══════════════════════════════════════════════════

In the same agentic-architect/ folder, create another Google Doc called "icp.md"
- Open the local file at /home/sophia-stein/bsw/handouts/icp-md-template.md and copy its entire contents into the icp.md Google Doc.
- Copy the file ID and add to the temp credentials tab.

═══════════════════════════════════════════════════
TASK 6 · IMPORT n8n WORKFLOW
═══════════════════════════════════════════════════

Return to your n8n.cloud tab.
- Click Workflows → Add → Import from File.
- Upload /home/sophia-stein/bsw/n8n/bsw-growth-agent-lite.json (the FREE-tier version using Groq + Jina).
- After import, click into each node and replace placeholder credentials:
  - REPLACE_GROQ_HEADER_AUTH → create new HTTP Header Auth credential, name "Groq API · Authorization Bearer", header name "Authorization", value "Bearer YOUR_GROQ_KEY"
  - REPLACE_GOOGLE_SHEETS_CRED → click Connect new credential → OAuth2 → sign in with sophia@agenticarchitect.ai · grant Sheets read+write access · pause for me to consent.
  - REPLACE_GOOGLE_DRIVE_CRED → similar OAuth2 flow for Drive (read-only) · pause for me to consent.
  - REPLACE_GMAIL_CRED → similar OAuth2 flow for Gmail (compose + send scopes) · pause for me to consent.
- Replace placeholder IDs in the workflow:
  - REPLACE_WITH_YOUR_SHEET_ID → use the Sheet ID from temp tab (4 spots in workflow)
  - REPLACE_WITH_VOICE_MD_FILE_ID → voice.md file ID from temp tab
  - REPLACE_WITH_YOUR_EMAIL@example.com → sophia@agenticarchitect.ai (digest recipient, 1 spot)

═══════════════════════════════════════════════════
TASK 7 · TEST RUN
═══════════════════════════════════════════════════

In n8n, click the Manual Trigger node → Execute Workflow.

Watch the execution flow through all nodes. Each node should turn green. If any turns red, tell me what error it shows.

After the workflow finishes:
- Open Gmail in a new tab → check Drafts folder. There should be ~5 fresh drafts.
- Open the BSW Discovery Engine sheet → Runs tab. Should have 1 new row.
- Open the same sheet → Sent tab. Should have ~5 new rows.

═══════════════════════════════════════════════════
TASK 8 · HANDOFF
═══════════════════════════════════════════════════

When done, give me a summary in chat with:
1. A confirmation that drafts appeared in Gmail (with one example subject line so I know voice match worked)
2. The total time elapsed
3. Any errors you saw and how you handled them
4. The temp credentials tab URL so I can verify nothing leaked

Then close all tabs except n8n and Gmail Drafts. Leave those open for me.

=== AUTOPILOT PROMPT FOR CLAUDE FOR CHROME · END ===
```

---

## What you need to be ready to do (when Claude for Chrome pauses)

| Pause type | What you do | Time |
|---|---|---|
| Google sign-in | Enter your Google password + 2FA code | 30 sec |
| Groq sign-up confirmation | Click "I agree" on Terms of Service | 5 sec |
| n8n.cloud sign-up | Click "Start Free Trial" + accept TOS | 10 sec |
| Google OAuth consent (3 times: Sheets, Drive, Gmail) | Click "Allow" on the OAuth consent screen | 5 sec each |
| Groq billing prompt | Should NOT appear · if it does, tell agent to skip | n/a |

**Total interactive time:** ~2 minutes across the whole 10-minute autopilot run.

---

## After Claude for Chrome finishes · verify everything works

```bash
# Run the credential smoke test from your terminal
cd /home/sophia-stein/bsw
GROQ_API_KEY=gsk_yourkeyhere ./scripts/test-credentials.sh
```

Should print four green checkmarks (Anthropic skip is fine if you didn't get an Anthropic key — we're free tier).

Then in n8n, run the **Manual Trigger** once more yourself. You should see:
- ✅ All nodes turn green
- ✅ 5 drafts in your Gmail Drafts folder
- ✅ 5 rows added to the `Sent` tab in the spreadsheet
- ✅ 1 row added to the `Runs` tab

If any of these are missing, the most common culprit is one of the placeholder IDs not getting replaced. Open the n8n workflow and grep for `REPLACE_` — there should be no results.

---

## Activate the cron for tomorrow morning

Once the manual run works:
1. Open the workflow in n8n
2. Click the **Active** toggle (top right)
3. The agent will fire daily at 7 AM your time

Tomorrow morning before the workshop, check your inbox. If 5 drafts arrived overnight, you're shipped. If not, debug Wednesday morning.

---

## Backup plan if Claude for Chrome stalls

If Claude for Chrome gets stuck on a step, you can:
1. Tell it to skip that step and continue
2. Do that step manually using the existing `TUTORIAL.md`
3. Then re-prompt: "Resume from Task X"

The 17-step manual TUTORIAL.md covers everything Claude for Chrome would have done.

---

## What this saves you

| Without autopilot | With Claude for Chrome |
|---|---|
| 30 min interactive setup | ~2 min interactive · ~10 min wall-clock |
| 10+ context switches | Zero context switches |
| Easy to miss a step | Agent cross-references against this script |
| ~$0 cost | ~$0 cost · same credentials used |

---

*Autopilot script v1 · for the BSW Growth Agent free-tier path · MIT licensed*
*— Sophia Stein · agenticarchitect.ai/blog · sophia@agenticarchitect.ai*
