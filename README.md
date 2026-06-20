# AI Native Lab — Landing page (linkhub)

The official linkhub for AI Native Lab. A single self-contained static page (HTML + inline CSS,
Be Vietnam Pro font) — no build step, no external libraries.

- **Production:** https://ainativelab.org  (Netlify site `inquisitive-sunburst-a83e04`)
- **Staging:** the staging Netlify site (base directory = `staging/`)
- **Domain/DNS:** Cloudflare → Netlify

## Two environments, one repo

```
.
├── netlify.toml      Production config — publish = "live" (read when base dir = repo root)
├── live/
│   └── index.html    PRODUCTION page → ainativelab.org. Produced by promote.sh — don't hand-edit.
├── staging/
│   ├── index.html    STAGING page — develop here
│   └── netlify.toml  Staging config — publish = "." (read when a site's base dir = staging/)
└── scripts/
    └── promote.sh    Copy staging/ → live/ (excludes netlify.toml)
```

Each environment is a separate **Netlify site building the same repo**, distinguished by
**base directory**: production uses the repo root (→ root `netlify.toml` → publishes `live/`),
staging uses `staging/` (→ `staging/netlify.toml` → publishes `staging/`). This avoids the
shared-config trap where one `netlify.toml` would force both sites to publish the same folder.

## Workflow (develop → preview → approve → promote → ship)

1. **Develop** in `staging/index.html`. Push `main` → the staging site redeploys automatically.
2. **Review** on the staging URL.
3. **Approve.**
4. **Promote:** `bash scripts/promote.sh --dry-run`, then `bash scripts/promote.sh`.
5. **Ship:** `git add -A && git commit -m "promote staging -> live" && git push` → production redeploys.

## Set up the staging Netlify site (one-time)

In Netlify: **Add new site → Import from Git →** `AI-Native-Lab/ainativelab-landing`, then set
**Base directory = `staging`** (leave publish/command to the committed `staging/netlify.toml`).
Both sites deploy from `main`; they differ only by base directory.
