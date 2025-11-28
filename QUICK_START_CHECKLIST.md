# Quick Start Checklist

Use this checklist to deploy the License Curation Workflow to your repository.

## Pre-Deployment (5 minutes)

- [ ] Clone or download this repository
- [ ] Run `bash verify_setup.sh` to verify all components are present
- [ ] Review `workflow_components/config/company-policy.yml`

## Customize Policy (10 minutes)

Edit `workflow_components/config/company-policy.yml`:

- [ ] Change `company_name` to your organization
- [ ] Add your approved licenses
- [ ] Add your forbidden licenses
- [ ] Review conditional licenses and approval workflow
- [ ] Save the file

## Deploy to Repository (5 minutes)

```bash
# Navigate to your target repository
cd /path/to/your/project

# Copy workflow components
cp -r /path/to/LicenseCurationToolkit/workflow_components .

# Copy GitHub Actions workflow
mkdir -p .github/workflows
cp /path/to/LicenseCurationToolkit/.github/workflows/advanced-integrated-workflow.yml .github/workflows/

# Commit and push
git add workflow_components/ .github/workflows/
git commit -m "Add license curation workflow"
git push
```

- [ ] Workflow components copied
- [ ] Workflow file copied
- [ ] Changes committed and pushed

## Optional: Enable AI Features (5 minutes)

If you want AI-powered curation reports:

- [ ] Sign up for Azure OpenAI (or have credentials ready)
- [ ] Go to repository Settings → Secrets → Actions
- [ ] Add secret: `AZURE_OPENAI_API_KEY`
- [ ] Add secret: `AZURE_OPENAI_ENDPOINT`
- [ ] Add secret: `AZURE_OPENAI_MODEL` (optional, e.g., `gpt-4o-mini`)

## Verify Deployment (5 minutes)

- [ ] Go to repository Actions tab
- [ ] Verify workflow appears in the list
- [ ] Manually trigger workflow (Actions → Select workflow → Run workflow)
- [ ] Wait for workflow to complete (5-15 minutes)
- [ ] Check for any errors in the workflow logs

## Review Reports (5 minutes)

- [ ] Go to repository Settings → Pages
- [ ] Verify Pages is enabled (Source: GitHub Actions)
- [ ] Wait 2-3 minutes for Pages deployment
- [ ] Visit `https://<your-org>.github.io/<your-repo>/`
- [ ] Review the compliance dashboard
- [ ] Check policy compliance report
- [ ] Review any detected issues

## Next Steps

After successful deployment:

- [ ] Share GitHub Pages URL with compliance team
- [ ] Set up notifications for workflow failures
- [ ] Schedule regular policy reviews (quarterly)
- [ ] Document any approved exceptions
- [ ] Monitor license change alerts

## Common Issues

### Workflow doesn't appear
- Check if `.github/workflows/advanced-integrated-workflow.yml` exists
- Verify file is in correct location
- Check GitHub Actions is enabled for repository

### No reports generated
- Verify workflow completed successfully
- Check GitHub Pages is enabled
- Wait 2-3 minutes for Pages deployment
- Check workflow logs for errors

### Policy compliance failures
- Review detected licenses in reports
- Update policy or find alternative packages
- Document any exceptions needed

## Getting Help

- Read [README.md](README.md) for quick start guide
- Check [DEPLOYMENT.md](DEPLOYMENT.md) for detailed instructions
- Review [workflow_components/README.md](workflow_components/README.md) for component docs
- Run `bash verify_setup.sh` to check setup

## Success!

Once you see the reports on GitHub Pages, you have successfully deployed the License Curation Workflow!

The workflow will now run automatically on:
- Every push to main/master/develop
- Every pull request
- Daily at 2 AM UTC (for license change monitoring)
- Manual trigger via GitHub Actions

---

Total Time: ~30 minutes (including first workflow run)
