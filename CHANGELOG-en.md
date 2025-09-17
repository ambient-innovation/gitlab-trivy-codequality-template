# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Calendar Versioning](https://calver.org/) (YY.MM.DD.MICRO).

## [Unreleased]

### Added

### Changed

### Fixed

### Deprecated

### Removed

### Security

## [25.09.17.0] - 2025-09-17
### Changed
- Updated Trivy scanner from v0.65.0 to v0.66.0
- Added a fault-tolerant cleanup workflow step: on a failed run the workflow will attempt to delete the update branch `update-trivy-<version>` locally and on the remote. If no such branch exists, the step exits without error.

## [25.08.19.0] - 2025-08-19
### Changed
- Version numbers in README and YAML-files are now updated in git as well as the release assets

## [25.08.15.0] - 2025-08-15
### Changed
- Updated Trivy GitLab CodeQuality plugin from v1.17.0 to v1.18.0

## [25.08.15.0] - 2025-08-15
### Changed
- Documentation updates

## [25.08.14.0] - 2025-08-14
### Fixed
- There were some references to the old repository name still in the config files that cannot be reached anymore

## [25.08.13.0] - 2025-08-13
### Added
- In the before_script an update-checker for the template was added
  It will print a message when the currently used template is outdated and show where to find the latest version.

### Changed
- replace trivy.template.yaml with trivy.default.yaml and update related documentation
- Update URLs in templates to use a TRIVY_TEMPLATE_VERSION variable
- Updated Trivy GitLab CodeQuality plugin from v1.16.0 to v1.17.0

### Removed
* remove deprecated trivy.template.yaml file

## [25.08.12.0] - 2025-08-12
### Changed
- Updated Trivy GitLab CodeQuality plugin from v1.15.0 to v1.16.0

## [25.08.06.2] - 2025-08-06

### Changed
- Table output can be configured now

## [25.08.06.1] - 2025-08-06

### Changed
- Updated Trivy GitLab CodeQuality plugin from v1.13.0 to v1.15.0

## [25.08.06.0] - 2025-08-06

### Changed
- Updated Trivy GitLab CodeQuality plugin from v1.2.0 to v1.13.0

## [25.08.05.1] - 2025-08-05

### Added
- New Workflows for updating trivy and the plugin to their latest versions

## [25.08.05.0] - 2025-08-05

### Added
- Trivy configuration merging: Automatic combination of template configuration with local `trivy.yaml`
- Version consistency: Release templates always reference the correct version of configuration files
- New configuration variables: `TRIVY_CONFIG_MERGE`, `TRIVY_TEMPLATE_CONFIG_URL`, `LOCAL_TRIVY_CONFIG`

### Changed
- All individual templates (`config-checks`, `license-checks`, `security-checks`) are now DEPRECATED
- Templates now show migration warnings when used
- GitHub Action now creates version-specific template files for releases

### Fixed
- Release templates now use correct URLs to their own version instead of `main` branch

### Deprecated
- `config-checks.template.yaml` - Use `trivy-scanning.template.yaml` with `PLUGIN_SEVERITY_MISCONFIG` instead
- `license-checks.template.yaml` - Use `trivy-scanning.template.yaml` with `PLUGIN_SEVERITY_LICENSE` instead  
- `security-checks.template.yaml` - Use `trivy-scanning.template.yaml` with `PLUGIN_SEVERITY_VULN` instead

## Usage

### Using New Features

```yaml
# Simple usage with automatic config merging
trivy-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    # Template automatically loads trivy.default.yaml and merges with local trivy.yaml
```

### Migration from Deprecated Templates

```yaml
# OLD (deprecated):
old-config-scan:
  extends: .config_scanning

# NEW (recommended):
new-config-scan:
  extends: .trivy_scanning
  variables:
    DIRECTORY: "./"
    PLUGIN_SEVERITY_MISCONFIG: "MEDIUM,HIGH,CRITICAL,UNKNOWN"
```

---

## How to Update the Changelog

1. **New features** → `Added` section
2. **Changes** → `Changed` section  
3. **Bug fixes** → `Fixed` section
4. **Deprecated features** → `Deprecated` section
5. **Removed features** → `Removed` section
6. **Security updates** → `Security` section

During a release, the `[Unreleased]` section is automatically renamed to the version number.
