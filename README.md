# Wonyeong Lee — Academic Homepage

A minimal, fast, fully static personal/CV website. No build step, no server, no cost.

```
index.html      ← all content (edit text here)
style.css       ← colors & layout (edit --variables at the top)
cv.pdf          ← your CV, linked by the "Curriculum Vitae" button
profile.jpg     ← your photo (add this file — see below)
```

---

## 1. Add your photo

Drop a square-ish image named **`profile.jpg`** into this folder.
(If you skip it, the page still works — the photo just won't show.)

## 2. Fill in your links

Open `index.html`, find the `<!-- TODO -->` lines in the **LINKS** block, and replace
`href="#"` with your real URLs (Google Scholar, GitHub, LinkedIn). Delete any link you don't want.

## 3. Preview locally (optional)

Just double-click `index.html` to open it in your browser. To use a local server instead:

```powershell
python -m http.server 8000
# then open http://localhost:8000
```

---

## 4. Deploy free on GitHub Pages

Your site will live at **`https://<username>.github.io`** — free forever, no card required.

### One-time setup

1. Create a GitHub account (if you don't have one): https://github.com/signup
2. Create a **new public repository** named exactly:
   ```
   <username>.github.io
   ```
   (e.g. if your username is `wonyeong`, the repo is `wonyeong.github.io`)
3. From this folder, push the files:

   ```powershell
   git init
   git add .
   git commit -m "Initial CV site"
   git branch -M main
   git remote add origin https://github.com/<username>/<username>.github.io.git
   git push -u origin main
   ```

4. On GitHub: **Settings → Pages** → Source = `Deploy from a branch`, Branch = `main` / `root` → **Save**.
5. Wait ~1 minute, then visit `https://<username>.github.io`. Done. 🎉

### Updating later

Edit the files, then:

```powershell
git add .
git commit -m "Update CV"
git push
```

The live site refreshes automatically within a minute.

---

## 5. (Optional) Custom domain

If you ever buy a domain (e.g. `wonyeong.dev`), add it under **Settings → Pages → Custom domain**.
GitHub Pages serves it over HTTPS for free — you only pay the domain registrar, never GitHub.
