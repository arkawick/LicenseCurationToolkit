# Deployment Guide

This guide explains how to deploy the License Curation Workflow to your repositories.

## Pre-Deployment Checklist

- [ ] Review and customize `workflow_components/config/company-policy.yml`
- [ ] (Optional) Set up Azure OpenAI credentials for AI features
- [ ] Verify your repository has GitHub Pages enabled (if you want reports published)
- [ ] Ensure you have admin access to the target repository

## Deployment Steps

### Option 1: Deploy to a Single Repository

```bash
# 1. Navigate to your target repository
cd /path/to/your/project

# 2. Copy workflow components
cp -r /path/to/LicenseCurationToolkit/workflow_components .

# 3. Copy GitHub Actions workflow
mkdir -p .github/workflows
cp /path/to/LicenseCurationToolkit/.github/workflows/advanced-integrated-workflow.yml .github/workflows/

# 4. Customize company policy
nano workflow_components/config/company-policy.yml

# 5. Commit and push
git add workflow_components/ .github/workflows/
git commit -m "Add license curation workflow"
git push
```

### Option 2: Deploy to Multiple Repositories

For organizations with many repositories, use this script:

```bash
#!/bin/bash
# deploy-to-repos.sh

REPOS=(
  "your-org/repo1"
  "your-org/repo2"
  "your-org/repo3"
)

TOOLKIT_PATH="/path/to/LicenseCurationToolkit"

for repo in "${REPOS[@]}"; do
  echo "Deploying to $repo..."

  # Clone repository
  git clone "git@github.com:$repo.git" "temp-$repo"
  cd "temp-$repo"

  # Copy components
  cp -r "$TOOLKIT_PATH/workflow_components" .
  mkdir -p .github/workflows
  cp "$TOOLKIT_PATH/.github/workflows/advanced-integrated-workflow.yml" .github/workflows/

  # Commit and push
  git add workflow_components/ .github/workflows/
  git commit -m "Add license curation workflow"
  git push

  # Cleanup
  cd ..
  rm -rf "temp-$repo"

  echo "✓ Deployed to $repo"
done

echo "Deployment complete!"
```

## Configuration

### 1. Company Policy Configuration

Edit `workflow_components/config/company-policy.yml`:

```yaml
company_license_policy:
  company_name: "Your Company Name"

  # Licenses you automatically approve
  approved_licenses:
    permissive:
      licenses:
        - "MIT"
        - "Apache-2.0"
        - "BSD-2-Clause"
        - "BSD-3-Clause"
        - "ISC"
      auto_approve: true
      risk_level: "low"

  # Licenses that need approval
  conditional_licenses:
    weak_copyleft:
      licenses:
        - "LGPL-2.1-only"
        - "LGPL-3.0-only"
        - "MPL-2.0"
      approval_required: true
      approvers:
        - "legal@yourcompany.com"
      risk_level: "medium"

  # Licenses you forbid
  forbidden_licenses:
    strong_copyleft:
      licenses:
        - "GPL-2.0-only"
        - "GPL-3.0-only"
        - "AGPL-3.0-only"
      reason: "Incompatible with proprietary distribution"
      action: "reject"

    proprietary_restricted:
      licenses:
        - "SSPL-1.0"
        - "Elastic-2.0"
        - "Commons-Clause"
      reason: "Not OSI approved, restricts commercial use"
      action: "reject"
```

### 2. GitHub Secrets (Optional - for AI Features)

Go to your repository → Settings → Secrets and variables → Actions → New repository secret

Add these secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `AZURE_OPENAI_API_KEY` | Your Azure OpenAI API key | `abc123...` |
| `AZURE_OPENAI_ENDPOINT` | Your Azure OpenAI endpoint | `https://your-resource.openai.azure.com/` |
| `AZURE_OPENAI_MODEL` | Deployment name (optional) | `gpt-4o-mini` |

**Cost Estimate:** ~$0.20-$0.33 per workflow run

### 3. GitHub Pages Setup

1. Go to repository Settings → Pages
2. Source: GitHub Actions
3. The workflow will automatically deploy reports to GitHub Pages

## Verification

After deployment, verify the setup:

```bash
# 1. Check workflow file exists
ls -la .github/workflows/advanced-integrated-workflow.yml

# 2. Check workflow_components
ls -la workflow_components/

# 3. Check config file
cat workflow_components/config/company-policy.yml

# 4. Trigger workflow manually
# Go to Actions tab in GitHub → Select workflow → Run workflow
```

## Testing with Sample Package

Before deploying to production repositories, test with the included sample:

```bash
# Copy sample package to a new repo
cp -r sample_conanx_package /tmp/test-repo
cd /tmp/test-repo

# Initialize git
git init
git add .
git commit -m "Initial commit"

# Deploy workflow
cp -r /path/to/LicenseCurationToolkit/workflow_components .
mkdir -p .github/workflows
cp /path/to/LicenseCurationToolkit/.github/workflows/advanced-integrated-workflow.yml .github/workflows/

# Push to GitHub and watch workflow run
git remote add origin <your-test-repo-url>
git push -u origin main
```

## Customization Options

### Workflow Triggers

Edit `.github/workflows/advanced-integrated-workflow.yml`:

```yaml
on:
  push:
    branches: [ master, main, develop ]  # Customize branches
  pull_request:
    branches: [ master, main, develop ]
  workflow_dispatch:  # Manual trigger
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM - adjust as needed
```

### Report Outputs

The workflow generates reports in these locations:

- **Policy Compliance:** `policy-reports/policy-compliance-report.html`
- **License Changes:** `policy-reports/license-changes-report.html`
- **Alternatives:** `alternatives/alternatives-{package}.html`
- **SBOM Compliance:** `sbom-compliance/ntia-compliance-report.html`
- **Dashboard:** `compliance-dashboard.html`
- **GitHub Pages:** `https://<org>.github.io/<repo>/`

### Disable AI Features

If you don't want to use AI features, the workflow will skip them automatically when secrets are not configured. No code changes needed.

### Adjust ScanCode Limit

By default, ScanCode scans max 20 packages to avoid timeouts. To adjust:

Edit `.github/workflows/advanced-integrated-workflow.yml` line ~500:

```yaml
SCAN_LIMIT=20  # Change to your desired limit
```

## Troubleshooting

### Workflow fails with "Policy file not found"

**Solution:** Ensure `workflow_components/config/company-policy.yml` exists

```bash
ls -la workflow_components/config/company-policy.yml
```

### No reports generated

**Check:**
1. Workflow completed successfully (check Actions tab)
2. GitHub Pages is enabled
3. Wait 2-3 minutes for Pages deployment

### ORT analyzer fails

**Common causes:**
- No package manifest files (package.json, requirements.txt, etc.)
- Unsupported package manager
- Network issues downloading dependencies

**Solution:** Check ORT documentation for supported package managers

### AI features not working

**Check:**
1. Secrets are properly configured
2. Azure OpenAI endpoint is accessible
3. Deployment name matches your Azure setup
4. API key has not expired

## Maintenance

### Regular Updates

```bash
# Pull latest toolkit changes
cd /path/to/LicenseCurationToolkit
git pull origin main

# Re-deploy to repositories
# Use deployment script from Option 2 above
```

### Policy Updates

Update `workflow_components/config/company-policy.yml` and commit:

```bash
cd your-repo
nano workflow_components/config/company-policy.yml
git add workflow_components/config/company-policy.yml
git commit -m "Update license policy"
git push
```

The workflow will automatically use the new policy on the next run.

### License History Tracking

The workflow maintains `.ort/license-history.json` to track changes. This file should be committed to version control for historical tracking.

```bash
git add .ort/license-history.json
git commit -m "Update license history"
git push
```

## Best Practices

1. **Start Conservative:** Begin with strict policies, relax as needed
2. **Version Control Policy:** Always commit policy changes with explanations
3. **Review Quarterly:** Schedule regular policy reviews
4. **Test First:** Use sample_conanx_package before production deployment
5. **Monitor Alerts:** Set up notifications for workflow failures
6. **Document Exceptions:** When approving conditional licenses, document why
7. **Keep History:** Commit `.ort/license-history.json` for audit trail

## Support

For issues or questions:

1. Check [workflow_components/README.md](workflow_components/README.md)
2. Review troubleshooting section above
3. Check GitHub Actions logs for detailed error messages
4. Verify all paths and configurations

## Next Steps

After successful deployment:

1. Review first workflow run results
2. Customize policy based on your dependencies
3. Set up monitoring/alerts for workflow failures
4. Share GitHub Pages URL with your compliance team
5. Schedule regular compliance reviews

---

Last Updated: 2025-11-28
