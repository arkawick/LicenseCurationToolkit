#!/bin/bash

# Verification script for License Curation Toolkit
# This script verifies that all necessary components are present and properly configured

echo "========================================="
echo "License Curation Toolkit - Setup Verification"
echo "========================================="
echo ""

ERRORS=0
WARNINGS=0

# Function to check file exists
check_file() {
    if [ -f "$1" ]; then
        echo "✓ $1"
        return 0
    else
        echo "✗ $1 (MISSING)"
        ((ERRORS++))
        return 1
    fi
}

# Function to check directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo "✓ $1/"
        return 0
    else
        echo "✗ $1/ (MISSING)"
        ((ERRORS++))
        return 1
    fi
}

# Check core workflow file
echo "Checking GitHub Actions workflow..."
check_file ".github/workflows/advanced-integrated-workflow.yml"
echo ""

# Check workflow_components structure
echo "Checking workflow_components directory..."
check_dir "workflow_components"
check_dir "workflow_components/config"
check_dir "workflow_components/scripts"
check_dir "workflow_components/docs"
echo ""

# Check configuration
echo "Checking configuration files..."
check_file "workflow_components/config/company-policy.yml"
echo ""

# Check all required scripts
echo "Checking required scripts..."
REQUIRED_SCRIPTS=(
    "policy_checker.py"
    "license_change_monitor.py"
    "alternative_package_finder.py"
    "extract_uncertain_packages.py"
    "fetch_pypi_licenses.py"
    "generate_scancode_reports.py"
    "spdx-validation-fixer.py"
    "sbom_compliance_checker.py"
    "ort_curation_script_html.py"
    "enhanced_ai_curation.py"
    "ai_missing_licenses_analyzer.py"
    "generate_license_comparison.py"
    "ai_multilayer_resolution.py"
    "smart_curation_engine.py"
    "generate_landing_page.py"
    "compliance_dashboard.py"
)

for script in "${REQUIRED_SCRIPTS[@]}"; do
    check_file "workflow_components/scripts/$script"
done
echo ""

# Check documentation
echo "Checking documentation files..."
check_file "README.md"
check_file "DEPLOYMENT.md"
check_file "workflow_components/README.md"
echo ""

# Check sample package
echo "Checking sample package..."
check_dir "sample_conanx_package"
if [ -d "sample_conanx_package" ]; then
    check_file "sample_conanx_package/pyproject.toml"
fi
echo ""

# Check for removed directories (should not exist)
echo "Checking for removed directories (should NOT exist)..."
if [ -d "LicenseCurationTool-main" ]; then
    echo "⚠ LicenseCurationTool-main/ still exists (should be removed)"
    ((WARNINGS++))
else
    echo "✓ LicenseCurationTool-main/ correctly removed"
fi
echo ""

# Validate workflow references
echo "Validating workflow script references..."
WORKFLOW_FILE=".github/workflows/advanced-integrated-workflow.yml"
if [ -f "$WORKFLOW_FILE" ]; then
    # Extract script references from workflow
    REFERENCED_SCRIPTS=$(grep -oP "workflow_components/scripts/\K[^'\" ]+\.py" "$WORKFLOW_FILE" | sort -u)

    MISSING_SCRIPTS=0
    for script in $REFERENCED_SCRIPTS; do
        if [ ! -f "workflow_components/scripts/$script" ]; then
            echo "✗ Referenced in workflow but missing: $script"
            ((ERRORS++))
            ((MISSING_SCRIPTS++))
        fi
    done

    if [ $MISSING_SCRIPTS -eq 0 ]; then
        echo "✓ All workflow-referenced scripts are present"
    fi
else
    echo "✗ Cannot validate - workflow file missing"
    ((ERRORS++))
fi
echo ""

# Check Python syntax (if python is available)
if command -v python3 &> /dev/null; then
    # Check if it's the real python, not Windows Store stub
    if python3 --version &> /dev/null; then
        echo "Checking Python script syntax..."
        SYNTAX_ERRORS=0
        for script in workflow_components/scripts/*.py; do
            if [ -f "$script" ]; then
                if python3 -m py_compile "$script" 2>/dev/null; then
                    # Syntax OK - don't print to reduce noise
                    :
                else
                    echo "✗ Syntax error in: $script"
                    ((SYNTAX_ERRORS++))
                    ((ERRORS++))
                fi
            fi
        done

        if [ $SYNTAX_ERRORS -eq 0 ]; then
            echo "✓ All Python scripts have valid syntax"
        fi
        echo ""
    else
        echo "ℹ Python3 found but not configured - skipping syntax check"
        echo "  (Syntax will be checked by GitHub Actions)"
        echo ""
    fi
else
    echo "ℹ Python3 not available locally - skipping syntax check"
    echo "  (Syntax will be checked by GitHub Actions)"
    echo ""
fi

# Summary
echo "========================================="
echo "Verification Summary"
echo "========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✓ All checks passed!"
    echo ""
    echo "Your License Curation Toolkit is properly configured."
    echo "You can now deploy it to your repositories."
    echo ""
    echo "Next steps:"
    echo "1. Review and customize workflow_components/config/company-policy.yml"
    echo "2. Read DEPLOYMENT.md for deployment instructions"
    echo "3. Test with sample_conanx_package"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠ Verification completed with $WARNINGS warning(s)"
    echo ""
    echo "The toolkit is functional but some optional components are missing."
    exit 0
else
    echo "✗ Verification failed with $ERRORS error(s) and $WARNINGS warning(s)"
    echo ""
    echo "Please fix the errors above before deploying."
    exit 1
fi
