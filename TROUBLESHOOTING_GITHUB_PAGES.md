# Troubleshooting GitHub Pages Reports

This guide helps diagnose why specific reports might not appear on GitHub Pages.

## Issue: "Multi-Layer License Comparison" Link Not Showing

The link for the Multi-Layer License Comparison report appears only if the `license-comparison.html` file was successfully generated and copied to the `public/` directory.

### Step 1: Check Workflow Logs

1. Go to your repository → **Actions** tab
2. Click on the most recent workflow run
3. Expand the step: **"Generate multi-layer license comparison report"**
4. Look for these indicators:

#### Success Indicators
```
🔍 Stage 9d: Generating multi-layer license comparison report...
  ✓ PyPI results found
  ✓ ScanCode results found
  ✓ Uncertain packages list found
  ✓ Enhanced SPDX found
Running generate_license_comparison.py...
✅ License comparison report generated (12345 bytes)
```

#### Failure Indicators
```
⚠️  ORT analyzer results not found, skipping comparison report...
```
OR
```
⚠️  License comparison generation failed, check license-comparison.log
```

### Step 2: Common Causes and Fixes

#### Cause 1: ORT Analysis Failed
**Symptom:** Workflow skips report generation because ORT results are missing

**Fix:**
1. Check the **"Run ORT Analyzer"** step in workflow logs
2. Ensure your project has a supported package manifest file:
   - `package.json` (npm)
   - `requirements.txt` or `pyproject.toml` (Python)
   - `pom.xml` (Maven)
   - `build.gradle` (Gradle)
   - etc.
3. If no package manager files exist, ORT has nothing to analyze

#### Cause 2: Script Execution Error
**Symptom:** Script fails with Python error

**Fix:**
1. Check for error messages in the workflow log
2. Common errors:
   - **Missing dependencies:** Fixed automatically by workflow (should not occur)
   - **YAML parsing error:** ORT result file might be corrupted
   - **File not found:** Paths might be incorrect

#### Cause 3: No Data Sources Available
**Symptom:** Report generated but empty or minimal

**Why it happens:**
The comparison report requires multiple data sources:
- ORT results (required)
- PyPI API results (optional but helpful)
- ScanCode results (optional but helpful)
- SPDX document (optional)

If only ORT results are available, the comparison might not be very useful, so the script may not generate a meaningful report.

**Fix:**
Ensure the workflow completes these stages:
- Stage 5: Extract uncertain packages
- Stage 6: PyPI license fetch
- Stage 7: ScanCode deep scan

### Step 3: Check File Copied to Public

1. In workflow logs, expand **"Prepare Pages Deployment"**
2. Look for:
   ```
   ✓ Multi-layer license comparison report
   ```

If this line is missing, the file wasn't generated in the previous step.

### Step 4: Verify Landing Page Generation

1. In workflow logs, expand **"Prepare Pages Deployment"**
2. Look for output from `generate_landing_page.py`:
   ```
   ✅ Detected files:
     ...
     License Comparison: license-comparison.html
   ```

If it says `License Comparison: N/A`, the file doesn't exist.

## Manual Test (Local)

If you want to test locally:

```bash
# 1. Run ORT analysis
ort analyze -i . -o ort-results/analyzer

# 2. Generate comparison report
python3 workflow_components/scripts/generate_license_comparison.py \
  --ort-result ort-results/analyzer/analyzer-result.yml \
  --output license-comparison.html

# 3. Check if file was created
ls -lh license-comparison.html

# 4. Open in browser
open license-comparison.html  # macOS
xdg-open license-comparison.html  # Linux
start license-comparison.html  # Windows
```

## Workarounds

### Temporary: Skip This Report

If you don't need the multi-layer comparison, you can ignore this report. The workflow will still generate:
- Compliance Dashboard
- Policy Compliance Report
- License Change Alerts
- ORT WebApp
- And other reports

### Permanent: Ensure All Stages Run

To maximize the value of the comparison report, ensure:

1. **PyPI fetch runs successfully**
   - Check Stage 6 logs
   - Ensure uncertain packages are detected

2. **ScanCode scans packages**
   - Check Stage 7 logs
   - Note: Limited to 20 packages by default to avoid timeout

3. **SPDX validation completes**
   - Check Stage 8 logs

## Force Report Generation

If you want to ensure the report always generates (even with minimal data):

Edit `.github/workflows/advanced-integrated-workflow.yml`:

Find the step **"Generate multi-layer license comparison report"** (around line 850)

Change:
```yaml
if [ ! -f ort-results/analyzer/analyzer-result.yml ]; then
  echo "⚠️  ORT analyzer results not found, skipping comparison report..."
  exit 0
fi
```

To:
```yaml
if [ ! -f ort-results/analyzer/analyzer-result.yml ]; then
  echo "❌ ERROR: ORT analyzer results required for comparison report"
  exit 1  # Fail the workflow instead of skipping
fi
```

This will make the workflow fail if ORT analysis doesn't complete, making it easier to diagnose the root cause.

## Check GitHub Pages Deployment

1. Go to repository **Settings** → **Pages**
2. Verify:
   - Source: **GitHub Actions** (not "Deploy from a branch")
   - Status shows: **"Your site is live at https://..."**

3. If Pages is not enabled:
   - Select **Source**: GitHub Actions
   - Save
   - Wait 2-3 minutes for deployment

## Expected Behavior

The Multi-Layer License Comparison report should:
- Always generate if ORT analysis completes
- Show licenses from ORT (declared)
- Optionally show licenses from PyPI API (if fetched)
- Optionally show licenses from ScanCode (if scanned)
- Highlight conflicts between sources
- Provide download links for full data

## Quick Diagnosis Checklist

Run through this checklist:

- [ ] ORT Analyzer step completed successfully
- [ ] At least one package was analyzed by ORT
- [ ] "Generate multi-layer license comparison report" step ran (not skipped)
- [ ] No Python errors in the step logs
- [ ] "Prepare Pages Deployment" shows "✓ Multi-layer license comparison report"
- [ ] GitHub Pages is enabled (Source: GitHub Actions)
- [ ] Pages deployment completed (check Actions → pages-build-deployment)
- [ ] Cleared browser cache and refreshed GitHub Pages

## Still Not Working?

If the report still doesn't show:

1. **Download workflow artifacts:**
   - Go to Actions → Recent run → Scroll down to "Artifacts"
   - Download "enhanced-reports"
   - Check if `license-comparison.html` exists

2. **Check the file size:**
   - If file exists but is very small (<1KB), it might be an error page
   - Open the file locally to see the actual error

3. **Enable debug logging:**
   Edit `.github/workflows/advanced-integrated-workflow.yml`, add at the top:
   ```yaml
   env:
     ACTIONS_STEP_DEBUG: true
   ```

4. **Report the issue:**
   - Include workflow run URL
   - Include relevant log sections
   - Include your `pyproject.toml` / `package.json` (to verify ORT can analyze it)

---

**Most Common Fix:** Ensure ORT Analyzer completes successfully by having a valid package manifest file (package.json, requirements.txt, etc.) in your repository.
