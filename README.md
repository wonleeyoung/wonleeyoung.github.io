# Wonyeong Lee — Academic Homepage

🌐 **Live: https://wonleeyoung.github.io**

A minimal, fast, fully static CV website. No build step, no server, no cost.

```
index.html      ← all content (edit text here)
style.css       ← colors & layout (edit the --variables at the top)
cv.pdf          ← your CV, linked by the "Curriculum Vitae" button
.nojekyll       ← tells GitHub Pages to serve files as-is (don't delete)
profile.jpg     ← your photo (add this file — see below)
```

---

## Still to personalize

- **Photo** — drop a square image named `profile.jpg` into this folder, then push (see below). Until then the photo simply doesn't show.
- **Google Scholar & LinkedIn** — these links are currently commented out in `index.html` (search for `Google Scholar` / `LinkedIn`). Paste your real URLs and remove the `<!-- -->` to enable them.
- **Email** — set to `lwy970327@naver.com`; edit the `mailto:` in `index.html` to change.

## Edit & preview locally

Double-click `index.html`, or run a local server:

```powershell
C:\Users\lwy97\miniconda3\python.exe -m http.server 8000
# then open http://localhost:8000
```

## Publish changes

This folder is the source for the `wonleeyoung.github.io` repository. After editing:

```powershell
git add .
git commit -m "Update CV"
git push origin main
```

The live site refreshes within ~1 minute. The first push will ask you to sign in to
GitHub (a browser window opens — approve once and it's remembered).

---

## Notes

- **Previous site backup** — the old GitProfile portfolio that used to live here is fully
  preserved on the `old-gitprofile-backup` branch. To bring it back:
  `git push --force origin old-gitprofile-backup:main`.
- **Custom domain (optional, still free)** — buy a domain, then add it under
  **Settings → Pages → Custom domain**. GitHub serves it over HTTPS for free; you only
  pay the registrar.
