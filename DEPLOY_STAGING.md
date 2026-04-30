Deployment options for temporary staging

Quick overview
- Render: recommended for fastest setup using the repo's root Dockerfile (`Dockerfile`).


Render steps (recommended)
1. Push your repo to GitHub.
2. In Render, create a new "Web Service" → connect GitHub repo → select `render.yaml` or choose the root `Dockerfile`.
3. Add required environment variables and secrets in the Render dashboard (e.g. `DATABASE_URL`, `REDIS_URL`, `JWT_SECRET`).
4. Deploy — Render will build the Docker image and expose the service. Note the public URL.

Automatic deploy via GitHub Actions
1. In Render: create the service (use `render.yaml` or select the root `Dockerfile`) and note the `Service ID` from the URL or service details.
2. In GitHub → Settings → Secrets and variables → Actions add these secrets:
	- `RENDER_API_KEY` — create from Render dashboard (Account → API Keys)
	- `RENDER_SERVICE_ID` — the service id noted in step 1
3. Push to `main` — the workflow `.github/workflows/deploy-render.yml` will call Render API and trigger a deploy which will build and release the service.

If you prefer Render to perform builds automatically without using the API trigger, simply connect the repo in Render and it will deploy on each push to the linked branch.

Notes
- Do NOT store production secrets in the repository. Use the hosting provider's secret storage.

Frontend adjustments
- Update the frontend API base URL to the staging URL provided by the platform (Render). Prefer using an environment variable such as `REACT_APP_API_URL` or equivalent in `admin`/mobile apps.

Notes
- Do NOT store production secrets in the repository. Use the hosting provider's secret storage.
- If you want, I can prepare a GitHub Actions workflow to auto-deploy on push to `main`.
