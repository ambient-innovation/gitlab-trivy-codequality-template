# Changelog

Alle wichtigen Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Calendar Versioning](https://calver.org/) (YY.MM.DD.MICRO).

## [Unreleased]

### Changed
- Updated Trivy scanner from v0.65.0 to v0.66.0
- Neuer Workflow-Schritt zur Bereinigung: Bei einem fehlgeschlagenen Lauf versucht der Workflow, den Update-Branch `update-trivy-<version>` lokal und remote zu löschen, falls vorhanden. Der Schritt ist fehlertolerant und macht nichts, wenn kein Branch existiert.

## [25.08.19.0] - 2025-08-19
### Changed
- Versionsnummern in README und YAML-Dateien werden jetzt zusätzlich zu den Release-assets auch in git geupdated

## [25.08.15.0] - 2025-08-15
### Changed
- Updated Trivy GitLab CodeQuality plugin from v1.17.0 to v1.18.0

## [25.08.15.0] - 2025-08-15
### Changed
- Dokumentations-Anpassungen

## [25.08.14.0] - 2025-08-14
### Fixed
- Passt die Repository-URL an einigen Stellen an die noch auf den alten Namen verweisen und nicht mehr erreicht werden konnten.

## [25.08.13.0] - 2025-08-13
### Added
- Im before_script wurde ein update-check für das template hinzugefügt
  Der gibt eine Nachricht aus wenn das aktuell genutzte Template veraltet ist und zeigt an wo die neueste Verison zu finden ist.

### Changed
- trivy.template.yaml durch trivy.default.yaml ersetzen und Dokumentation anpassen
- URLs in den Templates wurden angepasst um eine TRIVY_TEMPLATE_VERSION Variable statt einer fixen Versionsnummer zu benutzen
- Updated Trivy GitLab CodeQuality plugin from v1.16.0 to v1.17.0

### Removed
- veraltete trivy.template.yaml Datei wurde entfernt

## [25.08.12.0] - 2025-08-12
### Changed
- Updated Trivy GitLab CodeQuality plugin from v1.15.0 to v1.16.0

## [25.08.06.3] - 2025-08-06
## [25.08.06.2] - 2025-08-06

### Changed
- Tabellen-Ausgabe ist jetzt konfigurierbar

## [25.08.06.1] - 2025-08-06

### Changed
- Updated Trivy GitLab CodeQuality plugin from v1.13.0 to v1.15.0

## [25.08.06.0] - 2025-08-06

### Changed
- Updated Trivy GitLab CodeQuality plugin from v1.2.0 to v1.13.0

## [25.08.05.1] - 2025-08-05

### Added
- Neue Workflows um trivy und das Plugin auf die jeweils neueste Version zu updaten

## [25.08.05.0] - 2025-08-05

### Added
- Trivy-Konfiguration Merging: Automatische Kombination von Template-Konfiguration mit lokaler `trivy.yaml`
- Versionskonsistenz: Release-Templates referenzieren immer die korrekte Version der Konfigurationsdateien
- Neue Konfigurationsvariablen: `TRIVY_CONFIG_MERGE`, `TRIVY_TEMPLATE_CONFIG_URL`, `LOCAL_TRIVY_CONFIG`

### Changed
- Alle individuellen Templates (`config-checks`, `license-checks`, `security-checks`) sind jetzt DEPRECATED
- Templates zeigen jetzt Migrations-Warnungen bei der Verwendung
- GitHub Action erstellt jetzt versionsspezifische Template-Dateien für Releases

### Fixed
- Release-Templates verwenden jetzt korrekte URLs zu ihrer eigenen Version statt `main` Branch

### Deprecated
- `config-checks.template.yaml` - Nutze stattdessen `trivy-scanning.template.yaml` mit `PLUGIN_SEVERITY_MISCONFIG`
- `license-checks.template.yaml` - Nutze stattdessen `trivy-scanning.template.yaml` mit `PLUGIN_SEVERITY_LICENSE`  
- `security-checks.template.yaml` - Nutze stattdessen `trivy-scanning.template.yaml` mit `PLUGIN_SEVERITY_VULN`

### Removed

### Security

## Verwendung

### Neue Funktionen nutzen

```yaml
# Einfache Verwendung mit automatischem Config-Merging
trivy-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    # Template lädt automatisch trivy.default.yaml und merged mit lokaler trivy.yaml
```

### Migration von deprecated Templates

```yaml
# ALT (deprecated):
old-config-scan:
  extends: .config_scanning

# NEU (empfohlen):
new-config-scan:
  extends: .trivy_scanning
  variables:
    DIRECTORY: "./"
    PLUGIN_SEVERITY_MISCONFIG: "MEDIUM,HIGH,CRITICAL,UNKNOWN"
```

---

## Wie man das Changelog aktualisiert

1. **Neue Funktionen** → `Added` Sektion
2. **Änderungen** → `Changed` Sektion  
3. **Bugfixes** → `Fixed` Sektion
4. **Veraltete Features** → `Deprecated` Sektion
5. **Entfernte Features** → `Removed` Sektion
6. **Sicherheitsupdates** → `Security` Sektion

Bei einem Release wird der `[Unreleased]` Abschnitt automatisch in die Versionsnummer umbenannt.
