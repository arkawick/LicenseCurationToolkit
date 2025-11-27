# 📦 License Curation Toolkit - Deployment Guide

**Enterprise-grade license compliance automation for any project**

---

## 🎯 Quick Start

Deploy this complete license curation workflow to any project in **3 simple steps**:

### **Step 1: Copy Files**

```bash
# Copy workflow_components/ to your project root
cp -r workflow_components/ /path/to/your/project/

# Copy GitHub Actions workflow
cp -r .github/workflows/advanced-integrated-workflow.yml /path/to/your/project/.github/workflows/
```

### **Step 2: Configure Policy**

```bash
cd /path/to/your/project
# Python dependencies are automatically installed by the GitHub Actions workflow
# No manual installation required
```

### **Step 3: Commit and Push**

Edit `workflow_components/config/company-policy.yml` to match your license policy.

**That's it!** Push to GitHub and the workflow will run automatically.

---

## 📂 What You Get

### **Directory Structure**

```
your-project/
├── .github/
│   └── workflows/
│       └── advanced-integrated-workflow.yml    # Complete automation workflow
├── workflow_components/
│   ├── scripts/                                # 10+ Python automation scripts
│   │   ├── policy_checker.py                   # Policy compliance validation
│   │   ├── license_change_monitor.py           # Historical change tracking
│   │   ├── alternative_package_finder.py       # Forbidden package alternatives
│   │   ├── smart_curation_engine.py            # AI-assisted curation suggestions
│   │   ├── compliance_dashboard.py             # Executive compliance dashboard
│   │   ├── sbom_compliance_checker.py          # NTIA SBOM compliance (NEW)
│   │   ├── spdx-validation-fixer.py            # SPDX validation & fixing
│   │   ├── merge_scancode_to_spdx.py           # ScanCode → SPDX integration
│   │   ├── generate_landing_page.py            # Report landing page generator
│   │   ├── fetch_pypi_licenses.py              # PyPI fast license fetch
│   │   ├── generate_scancode_reports.py        # ScanCode report generator
│   │   ├── enhanced_ai_curation.py             # AI-powered curation (optional)
│   │   └── ... (more scripts)
│   ├── config/
│   │   └── company-policy.yml                  # License policy configuration
│   ├── diagrams/                               # Architecture diagrams
│   │   ├── 01_overall_system_architecture.drawio
│   │   └── 02_multi_tool_pipeline.drawio
│   ├── docs/                                   # Detailed documentation
│   │   ├── WORKFLOW_STRUCTURE.md               # Architecture overview
│   │   └── SPDX_INTEGRATION.md                 # SPDX & NTIA compliance guide
│   ├── README.md                               # Feature documentation
│   ├── DEPLOYMENT_GUIDE.md                     # This file
│   ├── IMPLEMENTATION_SUMMARY.md               # Implementation details
│   └── NEW_FEATURES_SUMMARY.md                 # Latest features (Smart Curation + Dashboard)
└── [your source code]
```

---

## 🔧 Configuration

### **1. License Policy (Required)**

Edit `workflow_components/config/company-policy.yml`:

```yaml
approved:
  - MIT
  - Apache-2.0
  - BSD-3-Clause
  - ISC

conditional:
  - LGPL-3.0-only:
      notes: "Requires legal review for dynamic linking"
      approval_required: true

forbidden:
  - GPL-3.0-only
  - AGPL-3.0-only

unknown_action: "flag_for_review"
```

### **2. GitHub Secrets (Optional, for AI features)**

Add these to your repository secrets for AI-powered curation:

- `AZURE_OPENAI_API_KEY` - Azure OpenAI API key
- `AZURE_OPENAI_ENDPOINT` - Azure OpenAI endpoint URL

**Note:** AI features are optional and will be skipped if secrets are not configured.

### **3. GitHub Pages (Recommended)**

Enable GitHub Pages in repository settings:
- **Settings** → **Pages** → **Source:** GitHub Actions
- Your reports will be published to: `https://[username].github.io/[repo]/`

---

## 🚀 Features Included

### **📋 Core Compliance Features**

✅ **Policy Enforcement** (Stage 2)
- Validate packages against company license policy
- Categorize: Approved, Conditional, Forbidden, Unknown
- Generate compliance score (0-100%)

✅ **License Change Monitoring** (Stage 3)
- Track license changes across versions
- Severity assessment (Critical/High/Medium/Low)
- Historical change tracking with git

✅ **Alternative Package Finder** (Stage 4)
- Find approved alternatives for forbidden packages
- Search PyPI for license-compatible options
- Generate detailed alternative analysis reports

✅ **Smart Curation Engine** (Stage 9.5) ⭐ NEW
- Multi-source evidence aggregation (ORT, PyPI, ScanCode)
- Confidence scoring (0-100%)
- Auto-ready curations (≥70% confidence)
- Manual review queue for low-confidence packages

✅ **Compliance Dashboard** (Stage 10.5) ⭐ NEW
- Unified executive compliance view
- Overall compliance score with risk assessment
- Priority action items (Critical → Low)
- Links to all generated reports

✅ **SBOM Compliance** (Stage 8d) ⭐ NEW
- NTIA minimum elements validation
- SPDX 2.3 specification compliance
- Multi-format SBOM export (JSON, YAML, Tag-Value, RDF)
- Official spdx-tools integration

### **🔍 Multi-Tool License Detection**

The workflow uses **6 layers of detection** for maximum accuracy:

1. **TIER 0: Policy Management** - Policy checking and enforcement
2. **TIER 1: ORT Analysis** - Declared and concluded licenses
3. **TIER 2: PyPI Fast API** - Quick license fetch (reduces ScanCode load)
4. **TIER 3: ScanCode** - Deep file-level license detection
5. **TIER 4: SPDX** - Standard SBOM format
6. **TIER 5: AI Analysis** (Optional) - GPT-4 powered resolution
7. **TIER 6: Smart Curation** - Multi-source intelligent suggestions
8. **TIER 7: Compliance Dashboard** - Executive reporting

### **📊 Generated Reports (13+)**

All reports published to GitHub Pages:

**Compliance & Policy:**
- 📊 **Compliance Dashboard** - Executive summary (all metrics)
- ✅ **Policy Compliance Report** - Package policy status
- 🔄 **License Change Alerts** - Historical change tracking
- 🔍 **Smart Curation Review Queue** - Manual verification needed
- 📋 **NTIA SBOM Compliance Report** - SBOM quality metrics ⭐ NEW

**License Detection:**
- 🤖 **AI Curation Reports** - GPT-4 analysis (if enabled)
- 🌐 **PyPI License Report** - Fast API results
- 🔬 **ScanCode Reports** - File-level detection
- 📈 **Multi-Layer Comparison** - Cross-tool analysis

**Alternative Packages:**
- 🔄 **Alternative Package Reports** - Forbidden package alternatives

**Standard Formats:**
- 📄 **SPDX (4 formats)** - JSON, YAML, Tag-Value, RDF ⭐ NEW
- 📦 **CycloneDX SBOM** - Industry standard
- 🌐 **ORT WebApp** - Interactive visualization
- 📊 **ORT Static HTML** - Traditional report

---

## 🔄 Workflow Stages (13+ Stages)

```
┌─────────────────────────────────────────────────────────┐
│  Stage 1: ORT Analysis                                  │
│  └─ Analyze dependencies, generate SPDX/CycloneDX       │
├─────────────────────────────────────────────────────────┤
│  Stage 2: Policy Check ⭐                               │
│  └─ Validate against company policy                     │
├─────────────────────────────────────────────────────────┤
│  Stage 3: License Change Monitor ⭐                     │
│  └─ Track historical license changes                    │
├─────────────────────────────────────────────────────────┤
│  Stage 4: Find Alternatives ⭐                          │
│  └─ Search for approved package alternatives            │
├─────────────────────────────────────────────────────────┤
│  Stage 5: PyPI License Fetch                            │
│  └─ Quick license lookup from PyPI API                  │
├─────────────────────────────────────────────────────────┤
│  Stage 6-7: ScanCode Analysis                           │
│  └─ Deep file-level license detection                   │
├─────────────────────────────────────────────────────────┤
│  Stage 8: SPDX Enhancement                              │
│  └─ Merge ScanCode results into SPDX                    │
├─────────────────────────────────────────────────────────┤
│  Stage 8 (Enhanced): SPDX Validation ⭐ NEW             │
│  └─ Official spdx-tools validation + auto-fix           │
├─────────────────────────────────────────────────────────┤
│  Stage 8c: SPDX Format Conversion ⭐ NEW                │
│  └─ Export: JSON, YAML, Tag-Value, RDF                  │
├─────────────────────────────────────────────────────────┤
│  Stage 8d: SBOM Compliance Check ⭐ NEW                 │
│  └─ NTIA minimum elements validation                    │
├─────────────────────────────────────────────────────────┤
│  Stage 9: AI-Powered Curation (Optional)                │
│  └─ GPT-4 analysis for uncertain packages               │
├─────────────────────────────────────────────────────────┤
│  Stage 9.5: Smart Curation Engine ⭐                    │
│  └─ Multi-source intelligent curation suggestions       │
├─────────────────────────────────────────────────────────┤
│  Stage 10: Prepare GitHub Pages                         │
│  └─ Copy all reports, generate landing page             │
├─────────────────────────────────────────────────────────┤
│  Stage 10.5: Compliance Dashboard ⭐                    │
│  └─ Generate unified executive dashboard                │
├─────────────────────────────────────────────────────────┤
│  Stage 11: Deploy to GitHub Pages                       │
│  └─ Publish all reports to GitHub Pages                 │
└─────────────────────────────────────────────────────────┘
```

**⭐ = New/Enhanced in latest version**

---

## 📝 Customization

### **Workflow Triggers**

Edit `.github/workflows/advanced-integrated-workflow.yml`:

```yaml
on:
  push:
    branches: [ main, develop ]  # Customize branches
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday (customize as needed)
  workflow_dispatch:  # Manual trigger
```

### **Skip Stages**

Comment out unwanted stages in the workflow file:

```yaml
# Disable AI curation if not needed
# - name: Generate main ORT curation report
#   ...

# Disable ScanCode if too slow
# - name: Run ScanCode on uncertain packages
#   ...
```

### **Adjust Thresholds**

Edit scripts to customize behavior:

**Policy scoring** (`scripts/policy_checker.py`):
```python
# Line ~450: Adjust compliance score calculation
APPROVED_WEIGHT = 100
CONDITIONAL_WEIGHT = 50
FORBIDDEN_PENALTY = -100
```

**Smart curation confidence** (`scripts/smart_curation_engine.py`):
```python
# Line ~200: Adjust confidence threshold
HIGH_CONFIDENCE_THRESHOLD = 70  # Change to 80 for stricter
```

**SBOM compliance** (`scripts/sbom_compliance_checker.py`):
```python
# Line ~90: Adjust minimum compliance score
NTIA_COMPLIANCE_THRESHOLD = 90  # Change to 95 for stricter
```

---

## 🔍 Troubleshooting

### **Common Issues**

**1. ORT Analysis Fails**

```bash
# Ensure ORT is installed
docker pull ort/ort

# OR install locally
# See: https://github.com/oss-review-toolkit/ort
```

**2. ScanCode Times Out**

```yaml
# In workflow: Increase timeout
timeout-minutes: 60  # Default is 30
```

**3. Missing Reports**

Check workflow logs:
```bash
# Look for these success messages:
✅ Policy compliance report generated
✅ NTIA compliance report generated
✅ Compliance dashboard generated
```

**4. GitHub Pages Not Publishing**

- Ensure GitHub Pages is enabled in repository settings
- Check workflow has `pages: write` permission
- Verify `index.html` exists in `public/` directory

**5. spdx-tools Not Found**

```bash
# Install spdx-tools
pip install spdx-tools>=0.8.2

# Or upgrade
pip install --upgrade spdx-tools
```

---

## 📊 Interpreting Results

### **Compliance Dashboard**

**Overall Score:**
- **95-100%**: ✅ EXCELLENT - Production ready
- **85-94%**: ✅ GOOD - Minor improvements needed
- **70-84%**: ⚠️ ACCEPTABLE - Action required
- **50-69%**: ⚠️ NEEDS IMPROVEMENT - Urgent action
- **<50%**: ❌ CRITICAL - Do not deploy

**Risk Levels:**
- **LOW**: No critical issues, high compliance
- **MEDIUM**: Some conditional approvals needed
- **HIGH**: Forbidden packages or critical changes
- **CRITICAL**: Multiple severe compliance violations

### **NTIA SBOM Compliance**

**Compliance Score:**
- **≥95%**: 🎉 Excellent SBOM quality
- **90-94%**: ✅ NTIA Compliant
- **75-89%**: ⚠️ Needs improvement
- **<75%**: ❌ Non-compliant

**Missing Elements:**
- **Author/Supplier**: Package provenance tracking
- **Version**: Component versioning
- **License**: License information completeness
- **Identifiers**: Unique SPDX IDs

---

## 🎯 Best Practices

### **1. Regular Monitoring**

- ✅ Review dashboard weekly
- ✅ Address **CRITICAL** items within 24 hours
- ✅ Address **HIGH** items within 7 days
- ✅ Review manual curation queue monthly

### **2. Policy Management**

- ✅ Keep policy file in version control
- ✅ Document approval reasons for conditional licenses
- ✅ Update forbidden list based on legal guidance
- ✅ Review policy quarterly

### **3. SBOM Quality**

- ✅ Aim for ≥90% NTIA compliance score
- ✅ Fix SPDX validation errors promptly
- ✅ Provide complete metadata (author, version, license)
- ✅ Export multiple SPDX formats for tool compatibility

### **4. Curation Workflow**

1. Run workflow on push
2. Review compliance dashboard
3. Process high-confidence smart curations
4. Manually verify low-confidence packages
5. Apply curations to `.ort/curations.yml`
6. Re-run workflow to verify

### **5. Team Collaboration**

- ✅ Share GitHub Pages URL with stakeholders
- ✅ Assign action items to developers
- ✅ Track compliance score trends over time
- ✅ Include compliance in PR reviews

---

## 🔐 Security & Privacy

### **Data Handling**

- ✅ All processing happens in GitHub Actions
- ✅ No license data sent to external services (except AI features)
- ✅ SBOM files contain only metadata, no source code
- ✅ Reports published to GitHub Pages (public or private)

### **AI Features (Optional)**

If using Azure OpenAI:
- ⚠️ Package names and license info sent to Azure OpenAI
- ⚠️ Review Azure OpenAI data privacy policy
- ✅ Can be completely disabled by not setting API keys

---

## 📚 Additional Resources

### **Documentation**

- **[README.md](README.md)** - Feature overview
- **[WORKFLOW_STRUCTURE.md](docs/WORKFLOW_STRUCTURE.md)** - Architecture details
- **[SPDX_INTEGRATION.md](docs/SPDX_INTEGRATION.md)** - SBOM & NTIA compliance ⭐ NEW
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Implementation guide
- **[NEW_FEATURES_SUMMARY.md](NEW_FEATURES_SUMMARY.md)** - Latest features

### **Diagrams**

- **[01_overall_system_architecture.drawio](diagrams/01_overall_system_architecture.drawio)** - System architecture
- **[02_multi_tool_pipeline.drawio](diagrams/02_multi_tool_pipeline.drawio)** - 9-tier detection pipeline

### **External Tools**

- **ORT**: https://github.com/oss-review-toolkit/ort
- **ScanCode**: https://github.com/nexB/scancode-toolkit
- **spdx-tools**: https://github.com/spdx/tools-python
- **SPDX Spec**: https://spdx.github.io/spdx-spec/
- **NTIA SBOM**: https://www.ntia.gov/sbom

---

## 🆘 Support

### **Issues & Questions**

1. Check [Troubleshooting](#-troubleshooting) section
2. Review workflow logs in GitHub Actions
3. Check individual script help: `python3 script.py --help`
4. Review documentation in `workflow_components/docs/`

### **Customization Help**

All scripts support `--help` flag:

```bash
python3 workflow_components/scripts/policy_checker.py --help
python3 workflow_components/scripts/sbom_compliance_checker.py --help
python3 workflow_components/scripts/compliance_dashboard.py --help
```

---

## ✅ Deployment Checklist

Before deploying to production:

- [ ] Copied `workflow_components/` to project root
- [ ] Copied workflow to `.github/workflows/`
- [ ] Dependencies auto-installed by workflow (no manual setup needed)
- [ ] Configured license policy (`config/company-policy.yml`)
- [ ] Enabled GitHub Pages in repository settings
- [ ] (Optional) Added Azure OpenAI secrets for AI features
- [ ] Triggered workflow manually to test (`Actions` → `Run workflow`)
- [ ] Reviewed generated compliance dashboard
- [ ] Verified GitHub Pages deployment
- [ ] Shared dashboard URL with team

---

## 📈 What's New (Latest Version)

### **SPDX & SBOM Enhancements** ⭐ (2025-01-21)

- ✅ Official **spdx-tools** integration for spec compliance
- ✅ **NTIA minimum elements** validation
- ✅ **Multi-format SPDX export**: JSON, YAML, Tag-Value, RDF
- ✅ SBOM quality metrics in **compliance dashboard**
- ✅ SPDX validation auto-fix with detailed error reporting
- ✅ **NTIA compliance report** with actionable recommendations

### **Smart Features** (2025-01-19)

- ✅ Smart Curation Engine with confidence scoring
- ✅ Compliance Dashboard with unified metrics
- ✅ Multi-source evidence aggregation
- ✅ Priority action items generation

### **Policy Management** (Earlier)

- ✅ Policy compliance checking
- ✅ License change monitoring
- ✅ Alternative package finder

---

## 🎉 Success Metrics

Track these KPIs to measure effectiveness:

| Metric | Target | Dashboard Location |
|--------|--------|--------------------|
| **Overall Compliance** | ≥95% | Compliance Dashboard → Overall Score |
| **SBOM Quality** | ≥90% | NTIA Compliance Report → Compliance Score |
| **Critical Violations** | 0 | Compliance Dashboard → Action Items |
| **License Coverage** | ≥98% | Policy Compliance → Unknown Packages |
| **Manual Review Time** | <2 hrs/week | Smart Curation Review Queue |
| **Forbidden Packages** | 0 | Policy Compliance → Forbidden |

---

**Made with ❤️ for compliance teams**

*Ready to deploy? Copy `workflow_components/` and `.github/workflows/` to your project!*
