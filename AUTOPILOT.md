# Claude for Chrome · Autopilot Setup
## Hands-off setup for the BSW Growth Agent demo

> Two paths — pick one. **Free** uses Groq + Jina + n8n.cloud trial (no card, ~10 min). **Paid** uses Anthropic + Firecrawl + n8n.cloud trial (~$5–$15 to fund, better voice match).
>
> Paste the prompt for your path into Claude for Chrome (claude.com/chrome). Stay nearby — you'll need to enter passwords, accept OAuth screens, and click 2FA.

---

## Pre-flight (1 minute · do this first manually, both paths)

1. Sign into Chrome with the Google account that will own the agent
2. Open this file in a Chrome tab so the Claude extension can read the prompt
3. Open `/home/sophia-stein/bsw/handouts/voice-md-template.md` and `/home/sophia-stein/bsw/handouts/sheet-tab-icp.csv` in additional tabs — the agent will copy from these
4. Have your phone ready for 2FA codes

---

## Hard guardrails for Claude for Chrome (apply to BOTH paths)

When you paste the prompt below, the prompt itself starts with these guardrails. They prevent the most common ways an autopilot run goes off-script:

- ❌ **Do NOT write Google Apps Script.** This agent runs on n8n, not Apps Script. Anything that says "Tools → Script editor" is wrong.
- ❌ **Do NOT create a Jina or Algolia or Reddit account.** All three are used via public no-auth endpoints. There is nothing to sign up for.
- ❌ **Do NOT improvise alternative tools** ("I'll use Make.com instead", "I'll write a Python script"). The plan is fixed.
- ❌ **Do NOT skip OAuth consent screens.** Pause and let the human click Allow.
- ❌ **Do NOT proceed if a step fails.** Stop, report the error verbatim, wait for human guidance.
- ❌ **Do NOT paste code into Code nodes manually.** The JSON file already contains the post-debug code in every node. Importing the JSON is sufficient — no copy-pasting from `n8n/*.js`.
- ❌ **Do NOT manually re-wire nodes** (Sheets parallel branch, Build Digest Body, etc.). The JSON ships with the corrected topology.

### Known-acceptable diagnostics (don't treat these as failures)

- **Reddit returns 0 results across all 6 fallback hosts** → expected. n8n Cloud IPs are commonly blocked. Diagnostic line: `Reddit 0→0 (none)`. Workflow continues with HN + Lobsters.
- **Lobsters returns N stories but 0 pass quality filter** → expected for AI/SaaS ICPs. Lobsters surfaces general dev content; rarely intersects ICP-specific keywords.
- **voice.md "binary/DOCX" warning** in Build Draft Body console → workflow falls back to a built-in voice automatically. Drafts still ship.
- **`<handle>@verify-on-hn.example` in some sendTo fields** → expected when HN profile has no email. The draft footer includes the profile URL for human verification before sending.

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## PATH A · FREE TIER (Groq + Jina, no card)
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Workflow file: `n8n/bsw-growth-agent-lite.json`. Uses Groq's free **Llama 4 Scout** (discovery + drafting) cascading to **Llama 3.1 8B Instant** (cheap classification) + HN Algolia + Reddit JSON + Jina Reader. Total cost: $0 within free tiers. Quality: noticeably below Sonnet 4.6 voice match — fine for evaluation, not ideal for live customer outreach.

> ⚠️ **Path A status (2026-05-07):** the lite JSON does NOT yet have the demo-day fixes baked in (Reddit cloud-IP fallback, voice.md binary detection, parallel sheet branch, Build Digest Body, Gmail expression mode). For the workshop demo, **use Path B (paid tier)** — its JSON has all fixes. If you want to use Path A anyway, follow the manual steps in `n8n/README.md` after import.

### Free-path autopilot prompt

Copy everything between the `=== BEGIN ===` / `=== END ===` markers and paste into Claude for Chrome.

```
=== AUTOPILOT PROMPT · FREE TIER · BEGIN ===

You are setting up the BSW Growth Agent (FREE tier) for a founder. Stack: n8n.cloud (orchestration) + Groq (LLM, free) + HN Algolia + Reddit JSON + Jina Reader (all no-auth, no signup) + Google Sheets/Drive/Gmail.

GUARDRAILS — read and follow exactly:
1. Do NOT write Google Apps Script. We use n8n.
2. Do NOT create Jina, Algolia, or Reddit accounts. They use public no-auth endpoints.
3. Do NOT substitute different tools (Make.com, Zapier, custom scripts).
4. Pause for human approval at every OAuth consent screen, password prompt, and 2FA step.
5. If any step fails, STOP and report the verbatim error. Do not retry or work around it.

CREDENTIAL HANDLING:
Open a single new tab titled "BSW credentials" and write each value as plain text in this format. Do NOT paste into chat or email:

  GROQ_API_KEY=gsk_...
  N8N_INSTANCE_URL=https://...n8n.cloud
  GOOGLE_SHEET_ID=1AbC...XyZ
  VOICE_MD_FILE_ID=...

═══════════════════════════════════════════════════
TASK 1 · GROQ FREE TIER (LLM)
═══════════════════════════════════════════════════
1. Open https://console.groq.com in a new tab.
2. Sign in with the founder's Google account.
3. Navigate to API Keys.
4. Create a new key named "bsw-growth-agent". Copy it (starts with "gsk_") to the credentials tab.
5. CONFIRM no credit card was requested. If one was, STOP and tell the human.

═══════════════════════════════════════════════════
TASK 2 · n8n.CLOUD (workflow runtime)
═══════════════════════════════════════════════════
1. Open https://n8n.cloud in a new tab.
2. Start the 14-day free trial. Use Google SSO if offered. NO credit card required.
3. Note the workflow URL (https://[name].app.n8n.cloud) and write it to the credentials tab.
4. Do NOT import the workflow yet — we need the Sheet and Drive IDs first.

═══════════════════════════════════════════════════
TASK 3 · GOOGLE SHEET (config storage)
═══════════════════════════════════════════════════
1. Open https://docs.google.com/spreadsheets/u/0/create in a new tab.
2. Rename to: BSW Discovery Engine
3. Create three tabs (right-click bottom tab area → Add Sheet). Name them exactly: ICP, Sent, Runs.
4. ICP tab Row 1 headers (cells A1, B1, C1):
     icp_description     signal_keywords     subreddits
5. ICP tab Row 2 — copy the contents of /home/sophia-stein/bsw/handouts/sheet-tab-icp.csv into A2, B2, C2 (open the file, copy each cell value).
6. Sent tab Row 1 headers (A1–H1) — **case-sensitive, must match exactly** (n8n's "Append" silently drops mismatched columns):
     date  person  signal_type  source_url  score  draft_subject  send_to  status
7. Runs tab Row 1 headers (A1–F1):
     date  leads_found  qualified  drafts  errors  notes
8. Sent and Runs stay empty under headers — the agent will append rows.
9. Copy the spreadsheet ID from the URL (the long string between /d/ and /edit) to the credentials tab.

═══════════════════════════════════════════════════
TASK 4 · GOOGLE DRIVE FOLDER + voice.md
═══════════════════════════════════════════════════
1. Open https://drive.google.com in a new tab.
2. Click the gear icon (top right) → Settings → uncheck "Convert uploads to Google Docs editor format". This is critical — if Drive auto-converts the .md upload to a Google Doc, the workflow gets binary DOCX bytes instead of text. Save.
3. Create a folder called "agentic-architect" in My Drive root.
4. Inside the folder, click "+ New" → "File upload" → upload /home/sophia-stein/bsw/handouts/voice-md-template.md as-is. Do NOT create a Google Doc.
5. After upload, the file should show with a markdown icon, not a blue Doc icon.
6. Right-click voice.md → Share → Get link → copy. Extract the file ID (between /d/ and /view) and add to the credentials tab.

(Fallback: if Drive's setting can't be changed and the file lands as a Google Doc, the workflow has the Drive node configured with `googleFileConversion → text/plain` — it will export the Doc as plain text on download. So the workflow still works, but verify the voice in your first draft.)

═══════════════════════════════════════════════════
TASK 5 · IMPORT n8n WORKFLOW
═══════════════════════════════════════════════════
1. Return to the n8n.cloud tab.
2. Workflows → Add → Import from File.
3. Upload: /home/sophia-stein/bsw/n8n/bsw-growth-agent-lite.json
4. After import, click each node with a placeholder credential and connect:
   - "Groq API · Authorization Bearer" → New HTTP Header Auth credential. Header name: Authorization. Header value: Bearer <GROQ_API_KEY>
   - "Google Sheets account" → New OAuth2 credential. Sign in with the founder's Google account. Pause for the human to click Allow.
   - "Google Drive account" → New OAuth2 credential. Pause for human Allow.
   - "Gmail account" → New OAuth2 credential. Pause for human Allow.
5. Replace placeholder IDs in the workflow:
   - REPLACE_WITH_YOUR_SHEET_ID → use GOOGLE_SHEET_ID (4 nodes)
   - REPLACE_WITH_VOICE_MD_FILE_ID → use VOICE_MD_FILE_ID (1 node)
   - REPLACE_WITH_YOUR_EMAIL@example.com → the founder's email (1 node, the digest recipient)

═══════════════════════════════════════════════════
TASK 6 · TEST RUN
═══════════════════════════════════════════════════
1. In n8n, click the Manual · Webhook node, then "Test workflow" (or trigger via the webhook URL).
2. Watch each node turn green. If any turns red, STOP and report the verbatim error.
3. NOTE: Path A's lite JSON does NOT yet have the demo-day fixes (Reddit cloud-IP fallback, voice.md binary detection, parallel sheet branch, Build Digest Body, expression-mode Gmail To). Some failure modes may surface here. Refer the human to /home/sophia-stein/bsw/n8n/README.md for manual fixes — do not attempt those fixes inside this autopilot run.
4. After the run, verify:
   - Gmail Drafts folder has ~5 new drafts
   - Sheet's Sent tab has ~5 new rows
   - Sheet's Runs tab has 1 new row
   - The founder received 1 digest email

═══════════════════════════════════════════════════
TASK 7 · HANDOFF
═══════════════════════════════════════════════════
Summarize in chat:
1. Confirmation that drafts appeared in Gmail (with one example subject line)
2. Total elapsed time
3. Any errors encountered and how they were resolved (if at all)
4. The credentials tab URL so the human can verify nothing leaked

Then close all tabs except n8n and Gmail Drafts. Leave those open.

=== AUTOPILOT PROMPT · FREE TIER · END ===
```

---

## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## PATH B · PAID TIER (Anthropic + Firecrawl)
## ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Workflow file: `n8n/bsw-growth-agent.json`. Uses Anthropic Claude (Haiku 4.5 + Sonnet 4.6 with prompt caching) + built-in `web_search` tool + Firecrawl. Cost: ~$0.21 per run = ~$6/month at default frequency. Voice match is noticeably better than the free tier.

### Paid-path autopilot prompt

```
=== AUTOPILOT PROMPT · PAID TIER · BEGIN ===

You are setting up the BSW Growth Agent (PAID tier) for a founder. Stack: n8n.cloud + Anthropic Claude + Firecrawl + Google Sheets/Drive/Gmail.

GUARDRAILS — read and follow exactly:
1. Do NOT write Google Apps Script. We use n8n.
2. Do NOT substitute alternative providers (no Groq, no OpenAI, no Make.com).
3. Pause for human approval at every OAuth consent, payment form, and 2FA step.
4. If any step fails, STOP and report the verbatim error.

CREDENTIAL HANDLING — write to a single tab titled "BSW credentials":

  ANTHROPIC_API_KEY=sk-ant-...
  FIRECRAWL_API_KEY=fc-...
  N8N_INSTANCE_URL=https://...n8n.cloud
  GOOGLE_SHEET_ID=1AbC...XyZ
  VOICE_MD_FILE_ID=...

═══════════════════════════════════════════════════
TASK 1 · ANTHROPIC API KEY
═══════════════════════════════════════════════════
1. Open https://console.anthropic.com.
2. Sign in with the founder's Google account.
3. Settings → API Keys → Create Key. Name it "bsw-growth-agent".
4. Copy the key (starts with "sk-ant-") to the credentials tab.
5. Settings → Billing → confirm at least $20 of credit. If none, STOP and ask the human to add credit.

═══════════════════════════════════════════════════
TASK 2 · FIRECRAWL API KEY
═══════════════════════════════════════════════════
1. Open https://firecrawl.dev.
2. Sign in (Google SSO works).
3. Dashboard → API Keys → copy the key (starts with "fc-") to the credentials tab.
4. Free tier gives 500 credits — plenty for evaluation.

═══════════════════════════════════════════════════
TASK 3 · n8n.CLOUD
═══════════════════════════════════════════════════
1. https://n8n.cloud → start 14-day trial (no card).
2. Note the URL to credentials tab. Do NOT import yet.

═══════════════════════════════════════════════════
TASK 4 · GOOGLE SHEET
═══════════════════════════════════════════════════
Same as Free Path Task 3. Three tabs (ICP, Sent, Runs) with the headers from sheet-tab-icp.csv / sheet-tab-sent.csv / sheet-tab-runs.csv. Save the Sheet ID.

═══════════════════════════════════════════════════
TASK 5 · GOOGLE DRIVE + voice.md
═══════════════════════════════════════════════════
Same as Free Path Task 4. Save the voice.md file ID.

═══════════════════════════════════════════════════
TASK 6 · IMPORT n8n WORKFLOW
═══════════════════════════════════════════════════
1. n8n.cloud → Workflows → Add → Import from File.
2. Upload: /home/sophia-stein/bsw/n8n/bsw-growth-agent.json (this file has all demo-day fixes baked in — DO NOT manually paste any code from the .js files in the n8n/ directory)
3. Wire credentials:
   - "Anthropic API · x-api-key" → New HTTP Header Auth. Header name: x-api-key. Value: <ANTHROPIC_API_KEY>
   - "Firecrawl API · Authorization Bearer" → New HTTP Header Auth. Header name: Authorization. Value: Bearer <FIRECRAWL_API_KEY>
   - "Google Sheets account" / "Google Drive account" / "Gmail account" → OAuth2, pause for human Allow on each.
4. Replace placeholder IDs (search the workflow for `REPLACE_`):
   - REPLACE_WITH_YOUR_SHEET_ID (4 nodes: Read ICP, Read Sent log, Append Sent log, Append Runs audit log)
   - REPLACE_WITH_VOICE_MD_FILE_ID (1 node: Read voice.md from Drive)
   - REPLACE_WITH_YOUR_EMAIL@example.com (1 node: Gmail · Send digest to founder)

═══════════════════════════════════════════════════
TASK 7 · TEST RUN + HANDOFF
═══════════════════════════════════════════════════
1. Click Manual · Webhook → Test workflow.
2. Watch the execution panel. Each node should turn green in sequence. Total time: 1-2 minutes.
3. Open Build Discovery Body's output. Console line should look like:
     Discovery: HN 50→25 | Reddit 0→0 (none) | Lobsters 35→0 | total 25
   Reddit 0 and Lobsters filtered=0 are NORMAL (cloud IP block, no ICP match). Don't chase them.
4. Verify:
   - Gmail Drafts folder has ~5 new drafts (each with a real or placeholder recipient)
   - Sheet's Sent tab has ~5 new rows including a populated `send_to` column
   - Sheet's Runs tab has 1 new row with leads_found > 0
   - The founder received exactly 1 digest email (not 5 — Build Digest Body collapses to one)
5. If a Code node turns red with "Cannot assign to read only property 'name'": the JSON wasn't fully imported. STOP, report verbatim, ask human.

Report the handoff summary: confirmed drafts (one example subject), elapsed time, any errors.

=== AUTOPILOT PROMPT · PAID TIER · END ===
```

---

## What you (the human) will do during the autopilot run

| Pause type | What you do | Time |
|---|---|---|
| Google sign-in | Enter password + 2FA | 30 sec |
| Anthropic billing (paid only) | Click through billing if not pre-funded | 30 sec |
| Google OAuth consent (Sheets, Drive, Gmail — 3×) | Click Allow | 5 sec each |
| Verify the credentials tab | Skim that nothing odd is there | 30 sec |

**Total interactive time:** ~2 minutes across the ~10-minute autopilot run.

---

## After the autopilot finishes · verify locally

```bash
cd /home/sophia-stein/bsw

# Free path:
GROQ_API_KEY=gsk_yourkey ./scripts/test-credentials.sh

# Paid path:
ANTHROPIC_API_KEY=sk-ant-... FIRECRAWL_API_KEY=fc-... ./scripts/test-credentials.sh
```

Then in n8n, hit the **Manual · Webhook** node → "Test workflow". You should see:
- ✅ All nodes turn green
- ✅ 5 drafts in Gmail Drafts
- ✅ 5 rows in `Sent` tab
- ✅ 1 row in `Runs` tab
- ✅ 1 digest email in your inbox

If anything is missing, search the imported workflow for `REPLACE_` — there should be no results. Any remaining placeholder is the most common failure cause.

---

## Customize for your own business · do this after the agent works once

The autopilot creates a working agent that targets *Sophia's* example ICP. Before you start emailing real prospects, change these 4 things to make the agent useful to **you**. All 4 are edited from a browser — no n8n changes needed.

| # | What to edit | Where | Why |
|---|---|---|---|
| 1 | **`voice.md`** | Drive → `agentic-architect/voice.md` | Replace with **5+ of your real outbound emails** + a short tone-notes block. The agent caches this and writes drafts in this voice. The single biggest lever for quality. |
| 2 | **`icp_description`** | Sheet → `ICP` tab → cell A2 | One sentence describing your ideal customer. Be specific: stage, role, pain, geography. Vague ICPs produce vague leads. |
| 3 | **`signal_keywords`** | Sheet → `ICP` tab → cell B2 | Comma-separated phrases your prospects say when they have the pain you solve. Examples: "hired SDR", "outbound costs", "Lindy credits". The agent searches for these verbatim. |
| 4 | **`subreddits`** | Sheet → `ICP` tab → cell C2 | Comma-separated subreddit names (no `r/` prefix) where your customers hang out. Default is generalist SaaS subs — replace with niche ones for better signal. |

**One n8n change** also worth doing once:
- **Digest recipient** — the `Gmail · Send digest to founder` node has a `sendTo` field. Replace `REPLACE_WITH_YOUR_EMAIL@example.com` with your address. (The autopilot did this for you, but double-check.)

**Optional tweaks** (most people leave these alone):
- **Cron schedule** — default is `0 13 * * *` (7am MDT). Adjust UTC for your timezone: PT=14, ET=11, UK=06, CET=05. Edit in the `Cron · Daily 7am MDT` node.
- **Score threshold** — default keeps leads scored ≥ 6. Edit `>= 6` in the `Parse · Extract qualified leads` JS code.
- **Drafts per run** — default 5. Edit `slice(0, 5)` in the `Dedup · top 5 fresh leads` JS code.

After any change to the Sheet or `voice.md`, the **next run** picks it up. No redeploy needed — that's the config-as-files pattern.

---

## Activate the cron

Once the manual run works:
1. Open the workflow in n8n
2. Toggle **Active** (top right)
3. The agent fires daily at 7am Boulder time (`0 13 * * *` UTC during MDT)

---

## Backup plan if Claude for Chrome gets stuck

1. Tell it to skip the failing step and continue
2. Do that step manually using the existing `TUTORIAL.md` (covers everything the autopilot does)
3. Re-prompt: "Resume from Task X"

---

*Autopilot script v2 · two paths · MIT licensed*
*— Sophia Stein · agenticarchitect.ai/blog · sophia@agenticarchitect.ai*
