# Deploying DAE-Assets as a Blender Remote Asset Library

This covers what's left to get `D:\DAE-Assets` live on GitHub Pages as a Blender **Remote Asset Library** (Blender 5.2 LTS's built-in feature — the "globe" entry type in Preferences → Asset Libraries), the same way `cedricvdk.github.io/3DLearningTools/Assets/` works.

## Where things stand right now

- `D:\DAE-Assets` is a git repo (origin: `https://github.com/DoCedric/DAE-Assets.git`) with one local commit (`assets.blend` + `.gitignore`) that **hasn't been pushed yet** — the GitHub repo is currently empty.
- I've already added an empty **`.nojekyll`** file to the folder for you (see step 2 for why it's required).
- Everything else below needs to run on your machine, since it needs your local Blender install and your git credentials.

## Step 1 — Confirm your Blender version

The `asset_listing generate` command is a **Blender 5.2 LTS** feature. Check `Help → About` — if you're on an older build, update first or the next step will fail.

## Step 2 — Generate the asset listing

Open a terminal (cmd/PowerShell) in `D:\DAE-Assets` and run:

```
cd D:\DAE-Assets
blender -b -c asset_listing generate .
```

(If `blender` isn't on your PATH, use the full path, e.g. `"C:\Program Files\Blender Foundation\Blender 5.2\blender.exe" -b -c asset_listing generate .`)

This creates, next to `assets.blend`:
- `_asset-library-meta.json` — library name/contact metadata
- a `_v1\` folder — the JSON asset index Blender actually reads
- WebP preview images for each asset

**Why `.nojekyll` matters:** GitHub Pages runs Jekyll by default, and Jekyll silently *drops* any file/folder starting with `_` — which is exactly how the listing files are named. Without `.nojekyll` at the repo root, the library would look empty to Blender even though the files are in the repo. It's already in place, so you're covered.

Re-run this same command any time you add, edit, or remove an asset or catalog — it needs to stay in sync with `assets.blend`.

## Step 3 — Fill in the library metadata

Open the generated `_asset-library-meta.json` in a text editor and fill in the placeholders:

```json
{
  "api_versions": { ... },
  "name": "DAE Assets",
  "contact": {
    "name": "Cedric Van der Kelen / Howest DAE",
    "url": "https://github.com/DoCedric/DAE-Assets",
    "email": "cedric.van.der.kelen@howest.be"
  }
}
```

Re-running the generator later won't overwrite this once it's filled in.

## Step 4 — Commit and push everything

```
git add .
git commit -m "Add asset listing for remote library"
git push -u origin main
```

This pushes the initial commit **and** the newly generated listing/preview files in one go.

## Step 5 — Turn on GitHub Pages

On `github.com/DoCedric/DAE-Assets`:

1. **Settings → Pages**
2. Under **Build and deployment → Source**, choose **Deploy from a branch**
3. **Branch: `main`**, folder **`/ (root)`** → **Save**
4. Wait ~1 minute; the same page will show **"Your site is live at `https://docedric.github.io/DAE-Assets/`"** (use the exact URL GitHub shows you — casing can vary).

GitHub Pages already satisfies everything Blender's docs require of the web server (correct `Content-Length` headers, serving files with query strings stripped, ETag support for cheap re-syncing) — no extra server config needed.

## Step 6 — Add it in Blender

**Preferences → Asset Libraries → `+`** → choose the remote/URL library type (globe icon, same as your `cedricvdk.github.io` entry) → paste:

```
https://docedric.github.io/DAE-Assets/
```

(trailing slash, matching the working example's `.../Assets/` pattern) → set **Import Method** to whatever you want students defaulting to (you used **Pack** for 3DLearningTools).

Also double-check **Preferences → System → Allow Online Access** is enabled — remote libraries need it, and it'll matter for students setting this up on lab machines too.

## Keeping it updated later

Every time the asset set changes:

```
cd D:\DAE-Assets
blender -b -c asset_listing generate .
git add .
git commit -m "Update assets"
git push
```

GitHub Pages redeploys automatically after the push (usually under a minute).

---
Source: [Blender Manual — Remote Asset Libraries](https://docs.blender.org/manual/en/latest/files/asset_libraries/remote_asset_libraries.html)
