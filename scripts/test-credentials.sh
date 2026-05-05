#!/usr/bin/env bash
# =====================================================================
# BSW Growth Agent · credential smoke test
# Run this AFTER you've gathered your API keys, BEFORE you wire them
# into n8n. Catches typos/auth issues in 60 seconds, not 30 minutes.
#
# Usage:
#   ANTHROPIC_API_KEY=sk-ant-... \
#   FIRECRAWL_API_KEY=fc-...    \
#   GROQ_API_KEY=gsk_...        \
#   ./scripts/test-credentials.sh
#
# Set only the keys for the tier you're using. Skip the rest.
# =====================================================================

set -e
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[0;33m'; CYAN='\033[0;36m'; RESET='\033[0m'

ok() { echo -e "  ${GREEN}✓${RESET} $1"; }
fail() { echo -e "  ${RED}✗${RESET} $1"; }
skip() { echo -e "  ${YELLOW}–${RESET} $1 (no key set)"; }

echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${CYAN}BSW Growth Agent · credential smoke test${RESET}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

# -------------------- Anthropic --------------------
echo ""
echo -e "${CYAN}1 · Anthropic (Claude)${RESET}"
if [ -n "${ANTHROPIC_API_KEY:-}" ]; then
  resp=$(curl -sS https://api.anthropic.com/v1/messages \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "content-type: application/json" \
    -d '{"model":"claude-haiku-4-5","max_tokens":20,"messages":[{"role":"user","content":"reply with the word OK"}]}')

  if echo "$resp" | grep -q '"content"'; then
    text=$(echo "$resp" | grep -oP '"text"\s*:\s*"\K[^"]+' | head -1)
    ok "Anthropic API key valid · Haiku 4.5 responded: \"$text\""
  else
    fail "Anthropic API call failed:"
    echo "    $resp" | head -c 300
  fi
else
  skip "ANTHROPIC_API_KEY"
fi

# -------------------- Firecrawl --------------------
echo ""
echo -e "${CYAN}2 · Firecrawl (web extraction)${RESET}"
if [ -n "${FIRECRAWL_API_KEY:-}" ]; then
  resp=$(curl -sS https://api.firecrawl.dev/v1/scrape \
    -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"url":"https://example.com","formats":["markdown"],"onlyMainContent":true}')

  if echo "$resp" | grep -q '"success":true'; then
    ok "Firecrawl API key valid · scraped example.com"
  else
    fail "Firecrawl API call failed:"
    echo "    $resp" | head -c 300
  fi
else
  skip "FIRECRAWL_API_KEY"
fi

# -------------------- Groq (free tier) --------------------
echo ""
echo -e "${CYAN}3 · Groq (free tier · Llama 3.3)${RESET}"
if [ -n "${GROQ_API_KEY:-}" ]; then
  resp=$(curl -sS https://api.groq.com/openai/v1/chat/completions \
    -H "Authorization: Bearer $GROQ_API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"model":"llama-3.3-70b-versatile","max_tokens":20,"messages":[{"role":"user","content":"reply with the word OK"}]}')

  if echo "$resp" | grep -q '"content"'; then
    text=$(echo "$resp" | grep -oP '"content"\s*:\s*"\K[^"]+' | head -1)
    ok "Groq API key valid · Llama 3.3 responded: \"$text\""
  else
    fail "Groq API call failed:"
    echo "    $resp" | head -c 300
  fi
else
  skip "GROQ_API_KEY"
fi

# -------------------- Jina Reader (no key) --------------------
echo ""
echo -e "${CYAN}4 · Jina Reader (no key needed)${RESET}"
resp=$(curl -sS "https://r.jina.ai/https://example.com" | head -c 200)
if echo "$resp" | grep -qi 'example\|domain'; then
  ok "Jina Reader is reachable · returned content"
else
  fail "Jina Reader unreachable. Network issue?"
fi

# -------------------- Summary --------------------
echo ""
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${CYAN}Smoke test complete.${RESET}"
echo ""
echo "Next step: import n8n/bsw-growth-agent.json (or bsw-growth-agent-lite.json"
echo "for the free-tier path) into n8n.cloud, paste these keys into the matching"
echo "credentials, and run the Manual Trigger to see drafts land in Gmail."
echo ""
