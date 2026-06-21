# AI Native Lab — Landing page (linkhub)

The official linkhub for AI Native Lab. A single self-contained static page (HTML + inline CSS,
Be Vietnam Pro font) — no build step, no external libraries.

- **Production:** https://ainativelab.org  (Netlify site `inquisitive-sunburst-a83e04`, builds `main`)
- **Staging:** the staging Netlify site (builds the `staging` branch)
- **Domain/DNS:** Cloudflare → Netlify

## One source, environments by branch

```
.
├── index.html      THE page — edit this. No live/ or staging/ copies.
└── netlify.toml    publish = "." — used by both Netlify sites (they differ by BRANCH).
```

There is **one copy** of the page. The two environments are git branches, not folders:

- `main` → production (**ainativelab.org**)
- `staging` → the staging Netlify site (a persistent staging URL)
- every **pull request** gets its own isolated **Deploy Preview** URL — this is the review gate

`main` is protected: no direct pushes; changes land only via a reviewed PR. Merging the PR *is*
the promotion — there is no `promote.sh` and no second copy to keep in sync.

## Workflow (branch → preview → review → merge → live)

1. **Branch:** `git switch -c feat/my-change` off `main`. Edit `index.html`.
2. **Preview:** push the branch and open a PR into `main`. Netlify posts a **Deploy Preview URL**
   on the PR within a minute.
3. **Review** on that preview URL.
4. **Merge** the PR → `main` redeploys to **ainativelab.org**. Done.

Want a longer soak before shipping? Merge into the `staging` branch first to see it on the staging
Netlify site, then PR `staging` → `main` when happy.

## Netlify setup (one-time)

Both sites import `AI-Native-Lab/ainativelab-landing`, base directory = repo root (they read the
committed `netlify.toml`). They differ only by **production branch**:

- **Production site** `inquisitive-sunburst-a83e04`: production branch = `main`; Deploy Previews
  enabled (Site config → Build & deploy → Deploy Previews → "Any pull request…").
- **Staging site**: production branch = `staging`.
