# SPDX & NTIA SBOM Compliance Guide

**Official spdx-tools integration for enterprise SBOM compliance**

---

## 📋 Overview

This guide covers the **SPDX and NTIA SBOM compliance** features added to the License Curation Toolkit, including:

- ✅ Official **spdx-tools** Python library integration
- ✅ **NTIA minimum elements** validation
- ✅ **Multi-format SPDX export** (JSON, YAML, Tag-Value, RDF)
- ✅ SPDX **specification compliance** checking
- ✅ SBOM **quality metrics** and scoring
- ✅ **Compliance dashboard** integration

---

## 🎯 What is SPDX?

**SPDX** (Software Package Data Exchange) is an open standard for communicating software bill of materials (SBOM) information:

- **ISO/IEC 5962:2021** international standard
- Used by Linux Foundation, Apache, Eclipse, and more
- Machine-readable license and copyright information
- Supports multiple formats (JSON, YAML, XML, RDF, Tag-Value)

### **Why SPDX?**

- ✅ Industry standard for SBOM communication
- ✅ Required by many enterprises and government agencies
- ✅ Tool-agnostic format (works with any SBOM analyzer)
- ✅ Supports full dependency graphs
- ✅ Enables automated compliance checking

---

## 🏛️ What is NTIA?

**NTIA** (National Telecommunications and Information Administration) defined **minimum elements for SBOM**:

### **NTIA Minimum Elements:**

1. **Author Name** - Who created/supplied the component
2. **Component Name** - Designation for the unit of software
3. **Version of Component** - Identifier for a specific release
4. **Other Unique Identifiers** - e.g., SPDX ID, CPE
5. **Dependency Relationship** - Characterizing component dependencies
6. **Author of SBOM Data** - Who created the SBOM
7. **Timestamp** - When the SBOM was created

### **Why NTIA Compliance?**

- ✅ US government requirement for software suppliers (2025+)
- ✅ Industry best practice for software transparency
- ✅ Required by many Fortune 500 procurement policies
- ✅ Enables rapid vulnerability response (e.g., Log4Shell)

---

## 🔧 Components Added

### **1. spdx-tools Python Library**

**Installation:** Automatically installed by the workflow

```yaml
# In .github/workflows/advanced-integrated-workflow.yml
pip install pyyaml requests spdx-tools
```

**What it provides:**
- Official SPDX 2.3 specification validation
- Format conversion (JSON ↔ YAML ↔ Tag-Value ↔ RDF ↔ XML)
- SPDX document parsing and manipulation
- License expression validation

### **2. SBOM Compliance Checker Script**

**Location:** `workflow_components/scripts/sbom_compliance_checker.py`

**What it does:**
- Parses SPDX documents using spdx-tools
- Validates against SPDX 2.3 specification
- Checks NTIA minimum elements completeness
- Calculates compliance score (0-100%)
- Generates detailed HTML and JSON reports

**Usage:**
```bash
python3 workflow_components/scripts/sbom_compliance_checker.py \
  --spdx enhanced-spdx/bom-enhanced-fixed.spdx.json \
  --html-output sbom-compliance/ntia-compliance-report.html \
  --json-output sbom-compliance/ntia-compliance.json
```

### **3. Enhanced SPDX Validation (Workflow Stage 8)**

**What changed:**
- Added official `pyspdxtools --validate` command
- Detailed error reporting to GitHub Actions summary
- Auto-fix ORT-specific issues with custom validator
- Re-validation of fixed documents

**Workflow integration:**
```yaml
- name: Validate enhanced SPDX
  run: |
    # Official SPDX validation
    pyspdxtools -i enhanced-spdx/bom-enhanced.spdx.json --validate

    # Fix ORT-specific issues
    python3 workflow_components/scripts/spdx-validation-fixer.py \
      -i enhanced-spdx/bom-enhanced.spdx.json \
      -o enhanced-spdx/bom-enhanced-fixed.spdx.json

    # Re-validate
    pyspdxtools -i enhanced-spdx/bom-enhanced-fixed.spdx.json --validate
```

### **4. SPDX Format Conversion (Workflow Stage 8c)**

**Formats generated:**

| Format | Extension | Use Case |
|--------|-----------|----------|
| **JSON** | `.spdx.json` | API integration, programmatic processing |
| **YAML** | `.spdx.yml` | Version control, easier diffs, human-editable |
| **Tag-Value** | `.spdx.tv` | Human-readable audits, compliance reviews |
| **RDF** | `.spdx.rdf` | Semantic web tools, advanced SBOM analyzers |

**Workflow integration:**
```yaml
- name: Convert SPDX to multiple formats
  run: |
    # JSON to YAML
    pyspdxtools -i bom-enhanced-fixed.spdx.json -o bom.spdx.yml

    # JSON to Tag-Value
    pyspdxtools -i bom-enhanced-fixed.spdx.json -o bom.spdx.tv

    # JSON to RDF
    pyspdxtools -i bom-enhanced-fixed.spdx.json -o bom.spdx.rdf
```

### **5. SBOM Compliance Checking (Workflow Stage 8d)**

**What it checks:**

✅ **Document-level:**
- Creation timestamp present
- SPDX document ID valid
- Creator information complete

✅ **Package-level (for each package):**
- Supplier or originator specified (author)
- Component name present (required by SPDX)
- Version information provided
- SPDX ID unique identifier
- License concluded or declared
- Dependency relationships documented

**Compliance scoring:**
```
Score = 100 - (penalties × 100 / max_penalties)

Where penalties = count of:
  - Missing author/supplier
  - Missing version
  - Missing license
  - Missing SPDX ID
```

**Workflow integration:**
```yaml
- name: Check SBOM compliance (NTIA minimum elements)
  run: |
    python3 workflow_components/scripts/sbom_compliance_checker.py \
      --spdx enhanced-spdx/bom-enhanced-fixed.spdx.json \
      --html-output sbom-compliance/ntia-compliance-report.html \
      --json-output sbom-compliance/ntia-compliance.json
```

---

## 📊 Compliance Dashboard Integration

### **SBOM Metrics Section**

The compliance dashboard now includes SBOM quality metrics:

**Displayed metrics:**
- **Compliance Score** (0-100%) - Color-coded
- **Total Packages** - Package count
- **Missing License** - Packages without license info
- **Missing Author** - Packages without supplier/originator
- **Missing Version** - Packages without version
- **SPDX Errors** - Validation error count

**Example output:**
```
┌────────────────────────────────────────┐
│  SBOM Compliance (NTIA Minimum Elements) │
├────────────────────────────────────────┤
│  Compliance Score: 92%         [GREEN] │
│  Total Packages: 450                   │
│  Missing License: 15                   │
│  Missing Author: 8                     │
│  Missing Version: 2                    │
│  SPDX Errors: 0                        │
├────────────────────────────────────────┤
│  ✅ NTIA Compliant                    │
│  SBOM meets NTIA minimum requirements  │
└────────────────────────────────────────┘
```

### **Updated Overall Compliance Score**

The overall compliance calculation now includes SBOM quality:

**Formula:**
```
If SBOM data available:
  Base Score = (Policy Score × 60%) + (SBOM Score × 25%) + (100 × 15%)
Else:
  Base Score = Policy Score

Overall Score = Base Score - Critical Change Penalty - Forbidden Penalty - SBOM Quality Penalty

Where:
  - Policy Score: 0-100% (from policy compliance)
  - SBOM Score: 0-100% (from NTIA compliance)
  - Critical Change Penalty: Up to -20%
  - Forbidden Penalty: Up to -30%
  - SBOM Quality Penalty: Up to -10% (if SBOM < 75%)
```

### **Auto-Generated Action Items**

The dashboard automatically generates action items for SBOM issues:

**Example:**
```
Priority: HIGH
Type: SBOM Compliance
Package: 15 packages missing license
Action: Improve SBOM metadata to meet NTIA requirements
Deadline: 7 days
```

```
Priority: MEDIUM
Type: SPDX Validation
Package: 3 errors
Action: Fix SPDX specification validation errors
Deadline: 14 days
```

---

## 📄 Generated Reports

### **1. NTIA Compliance Report**

**File:** `public/ntia-compliance-report.html`

**Sections:**
- **Overall Compliance Score** - Large score circle with status badge
- **Quick Statistics** - Package counts and missing elements
- **NTIA Checklist** - All 7 elements with completion status
- **Validation Issues** - SPDX errors and warnings
- **Missing Elements Details** - Package-by-package breakdown
- **Recommendations** - Actionable improvement suggestions
- **About NTIA** - Educational content

**Visual features:**
- Color-coded compliance score (green/orange/red)
- Status badges (EXCELLENT/COMPLIANT/NEEDS IMPROVEMENT)
- Progress bars for each NTIA element
- Expandable package lists
- Responsive design

### **2. SPDX Formats (Multiple Files)**

**Files:** `public/spdx-formats/`

```
spdx-formats/
├── bom.spdx.json         # JSON format (API integration)
├── bom.spdx.yml          # YAML format (version control)
├── bom.spdx.tv           # Tag-Value format (human-readable)
└── bom.spdx.rdf          # RDF format (semantic web)
```

**Landing page integration:**
- Card showing all available formats
- Download buttons for each format
- Format descriptions

### **3. Compliance Dashboard**

**File:** `public/compliance-dashboard.html`

**New SBOM section includes:**
- 6-panel metrics grid
- Compliance score visualization
- NTIA status badge
- Color-coded missing elements
- Integration with overall score

---

## 🔍 Understanding Compliance Scores

### **SBOM Compliance Score Interpretation**

| Score | Status | Meaning | Action Required |
|-------|--------|---------|-----------------|
| **95-100%** | 🎉 EXCELLENT | Nearly perfect SBOM quality | Maintain quality |
| **90-94%** | ✅ COMPLIANT | Meets NTIA minimum requirements | Minor improvements |
| **75-89%** | ⚠️ NEEDS IMPROVEMENT | Some elements missing | Fill missing metadata |
| **<75%** | ❌ NON-COMPLIANT | Significant gaps | Urgent action required |

### **Common Missing Elements**

**Missing License (Most Critical)**
- Impact: Cannot assess license compliance
- Fix: Curate licenses using Smart Curation Engine
- Target: 0 packages

**Missing Author/Supplier**
- Impact: No provenance tracking
- Fix: Add supplier info to package metadata
- Target: <5% packages

**Missing Version**
- Impact: Cannot track vulnerabilities by version
- Fix: Ensure version info in package manifests
- Target: <2% packages

**SPDX Validation Errors**
- Impact: SPDX document may not parse in other tools
- Fix: Use spdx-validation-fixer.py or fix manually
- Target: 0 errors

---

## 🛠️ Using SPDX Formats

### **JSON Format (API Integration)**

```bash
# Download
curl https://your-pages-url/spdx-formats/bom.spdx.json > sbom.json

# Use with spdx-tools
python3 -m spdx_tools.spdx.parser.parse_anything sbom.json

# Validate
pyspdxtools -i sbom.json --validate
```

**Use cases:**
- Automated vulnerability scanning
- CI/CD pipeline integration
- SBOM management platforms
- API-based compliance checking

### **YAML Format (Version Control)**

```bash
# Better git diffs
git diff spdx-formats/bom.spdx.yml

# Edit manually (more readable than JSON)
vim spdx-formats/bom.spdx.yml

# Convert to JSON
pyspdxtools -i bom.spdx.yml -o bom.spdx.json
```

**Use cases:**
- Version control tracking
- Manual SBOM editing
- Merge conflict resolution
- Code reviews

### **Tag-Value Format (Human-Readable)**

```bash
# View in text editor
cat spdx-formats/bom.spdx.tv | less

# Search for specific package
grep "PackageName: requests" bom.spdx.tv -A 10
```

**Example:**
```
PackageName: requests
SPDXID: SPDXRef-Package-PyPI-requests-2.28.0
PackageVersion: 2.28.0
PackageSupplier: Organization: Python Software Foundation
PackageLicenseConcluded: Apache-2.0
PackageLicenseDeclared: Apache-2.0
```

**Use cases:**
- Compliance audits
- Manual review by legal teams
- Documentation generation
- Training and education

### **RDF Format (Semantic Web)**

```bash
# Use with RDF tools
rapper -i rdfxml bom.spdx.rdf

# Query with SPARQL
# (requires RDF database)
```

**Use cases:**
- Semantic web integration
- Advanced SBOM analytics
- Knowledge graph construction
- Linked data applications

---

## 📈 Improving SBOM Compliance

### **Step 1: Run Compliance Check**

```bash
# Generate reports
python3 workflow_components/scripts/sbom_compliance_checker.py \
  --spdx enhanced-spdx/bom-enhanced-fixed.spdx.json \
  --html-output compliance-report.html \
  --json-output compliance-data.json

# Open HTML report
open compliance-report.html  # Mac
# OR
start compliance-report.html  # Windows
```

### **Step 2: Address Missing Licenses**

**Use Smart Curation Engine:**
```bash
# Generate curation suggestions
python3 workflow_components/scripts/smart_curation_engine.py \
  --policy workflow_components/config/company-policy.yml \
  --ort-results ort-results/analyzer/analyzer-result.yml \
  --output-curations smart-curations.yml \
  --output-review manual-review-queue.html

# Review manual-review-queue.html
# Apply high-confidence curations to .ort/curations.yml
```

### **Step 3: Add Missing Metadata**

**For missing author/supplier:**
```yaml
# In .ort/curations.yml
curations:
  - id: "PyPI::package-name:1.0.0"
    curations:
      concluded_license: "MIT"
      authors:
        - "Package Author <author@example.com>"
```

**For missing version:**
- Ensure package managers report correct versions
- Check package manifest files (setup.py, package.json, etc.)

### **Step 4: Fix SPDX Validation Errors**

```bash
# Use built-in fixer
python3 workflow_components/scripts/spdx-validation-fixer.py \
  -i enhanced-spdx/bom-enhanced.spdx.json \
  -o enhanced-spdx/bom-enhanced-fixed.spdx.json

# Validate
pyspdxtools -i enhanced-spdx/bom-enhanced-fixed.spdx.json --validate
```

### **Step 5: Re-Run Workflow**

```bash
# Commit changes
git add .ort/curations.yml
git commit -m "Improve SBOM compliance metadata"
git push

# Workflow runs automatically
# Check new compliance score in dashboard
```

---

## 🎯 Best Practices

### **1. SBOM Quality Goals**

✅ **Target Metrics:**
- SBOM Compliance Score: ≥90%
- Missing Licenses: 0
- Missing Authors: <5%
- Missing Versions: <2%
- SPDX Validation Errors: 0

### **2. Regular Audits**

✅ **Weekly:**
- Check compliance dashboard
- Review SBOM compliance score
- Address critical missing elements

✅ **Monthly:**
- Full SBOM audit against NTIA checklist
- Update curations for uncertain packages
- Review and update license policy

✅ **Quarterly:**
- Export all SPDX formats
- Share with legal/compliance teams
- Archive for audit trails

### **3. Format Selection**

Choose SPDX format based on use case:

| Use Case | Recommended Format | Why |
|----------|-------------------|-----|
| **Vulnerability Scanning** | JSON | Fast parsing, tool support |
| **Version Control** | YAML | Better diffs, readable |
| **Compliance Audits** | Tag-Value | Human-readable, printable |
| **Tool Integration** | JSON | Universal support |
| **Legal Review** | Tag-Value | Easy for non-technical reviewers |
| **Archival** | JSON | Compact, widely supported |

### **4. Automation**

✅ **CI/CD Integration:**
```yaml
# Fail build if SBOM compliance < 90%
- name: Check SBOM Compliance
  run: |
    SCORE=$(jq '.compliance_score' sbom-compliance/ntia-compliance.json)
    if [ "$SCORE" -lt 90 ]; then
      echo "❌ SBOM compliance below 90%: $SCORE%"
      exit 1
    fi
```

✅ **Scheduled Audits:**
```yaml
# Weekly SBOM audit
on:
  schedule:
    - cron: '0 0 * * 1'  # Every Monday
```

---

## 📚 Additional Resources

### **SPDX Resources**

- **Specification:** https://spdx.github.io/spdx-spec/
- **Tools:** https://github.com/spdx/tools-python
- **Examples:** https://github.com/spdx/spdx-examples
- **License List:** https://spdx.org/licenses/

### **NTIA Resources**

- **SBOM Minimum Elements:** https://www.ntia.gov/sbom
- **SBOM Tool Survey:** https://www.ntia.doc.gov/files/ntia/publications/sbom_tools_survey-2021.pdf
- **Framing Guide:** https://www.ntia.gov/files/ntia/publications/framingsbom_20191112.pdf

### **Standards**

- **SPDX ISO Standard:** ISO/IEC 5962:2021
- **CycloneDX:** https://cyclonedx.org/
- **SWID:** ISO/IEC 19770-2:2015

---

## 🔐 Compliance & Legal

### **SPDX License**

- SPDX specification: CC-BY-3.0
- spdx-tools: Apache-2.0
- Can be used for commercial and government purposes

### **Data Privacy**

- ✅ SPDX documents contain only metadata (no source code)
- ✅ All processing happens locally or in GitHub Actions
- ✅ No external API calls (except optional AI features)
- ✅ Safe to share with auditors and compliance teams

### **Export Control**

- ✅ SPDX documents are not subject to US export control
- ✅ Can be shared internationally
- ✅ Commonly used for open source compliance

---

## ✅ SBOM Compliance Checklist

Use this checklist to verify NTIA minimum elements:

- [ ] **Author Name** - Supplier or originator for each package
- [ ] **Component Name** - Package names present (automatic with SPDX)
- [ ] **Version** - Version info for all packages
- [ ] **Unique Identifiers** - SPDX IDs generated correctly
- [ ] **Dependencies** - Dependency relationships documented
- [ ] **SBOM Author** - Creator info in SPDX document
- [ ] **Timestamp** - Document creation time present
- [ ] **License Info** - Concluded or declared license for each package

**Additional Quality Checks:**

- [ ] SPDX validation passes with 0 errors
- [ ] Compliance score ≥90%
- [ ] All 4 SPDX formats generated successfully
- [ ] Landing page shows SPDX formats card
- [ ] Compliance dashboard includes SBOM section
- [ ] NTIA compliance report generated

---

**Made with ❤️ for SBOM compliance**

*SPDX + NTIA = Enterprise-Ready Software Transparency*
