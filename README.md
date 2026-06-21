# AI Native Lab — Landing page (linkhub)

The official linkhub for AI Native Lab. A single self-contained static page (HTML + inline CSS,
Be Vietnam Pro font) — no build step, no external libraries.

- **Production:** https://ainativelab.org  (Netlify project `ainativelab`, builds `main`)
- **Staging:** https://staging.ainativelab.org  (a **branch deploy** of the same project, builds `staging`)
- **Domain/DNS:** Cloudflare → Netlify

## One source, environments by branch

```
.
├── index.html      THE page — edit this. No live/ or staging/ copies.
└── netlify.toml    publish = "." — one config; production builds main, a branch deploy builds staging.
```

There is **one copy** of the page, and **one Netlify project** with shared build settings + env
vars. The environments are git branches — not folders, not separate projects:

- `main` → production (**ainativelab.org**)
- `staging` → **staging.ainativelab.org** (a persistent branch deploy on the same project)
- every **pull request** gets its own isolated **Deploy Preview** URL — this is the review gate

`main` is protected: no direct pushes; changes land only via a reviewed PR. Merging the PR *is*
the promotion — there is no `promote.sh` and no second copy to keep in sync.

## Workflow (branch → preview → review → merge → live)

1. **Branch:** `git switch -c feat/my-change` off `main`. Edit `index.html`.
2. **Preview:** push the branch and open a PR into `main`. Netlify posts a **Deploy Preview URL**
   on the PR within a minute.
3. **Review** on that preview URL.
4. **Merge** the PR → `main` redeploys to **ainativelab.org**. Done.

Want a longer soak before shipping? Merge into the `staging` branch first to see it at
**staging.ainativelab.org**, then PR `staging` → `main` when happy.

## Netlify setup (one-time)

**One** Netlify project (`ainativelab`) imports `AI-Native-Lab/ainativelab-landing` (base dir =
repo root, reads the committed `netlify.toml`); production branch = `main`. Two environments via
branch deploy on that single project:

- **Branch deploy:** Site config → Build & deploy → Branches → "Let me add individual branches" →
  add `staging`. Netlify then serves it at `staging--ainativelab.netlify.app`.
- **staging.ainativelab.org** (DNS is Cloudflare; the apex is Cloudflare-**proxied**, so match it):
  1. Netlify → Domain management → add domain alias `staging.ainativelab.org` (routes the host to
     the staging branch deploy).
  2. Cloudflare → DNS → CNAME `staging` → `staging--ainativelab.netlify.app`, **Proxied (orange)**.
     Cloudflare's Universal SSL (`*.ainativelab.org`) serves the cert — same as the apex.
     ⚠️ Do **not** use grey/DNS-only here: while the apex is Cloudflare-proxied, Netlify can't issue
     a per-alias cert (the proxy breaks its TLS-ALPN challenge → 422), so a grey record gets no cert.
- **Deploy Previews:** Build & deploy → Deploy Previews → "Any pull request…".

The old separate `ainativelab-staging` project is retired — delete it once staging.ainativelab.org serves.
