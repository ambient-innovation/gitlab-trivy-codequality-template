# Changelog

Alle wichtigen Änderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format basiert auf [Keep a Changelog](https://keepachangelog.com/de/1.0.0/),
und dieses Projekt folgt [Calendar Versioning](https://calver.org/) (YY.MM.DD.MICRO).

## [Unreleased]

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

## Verwendung

### Neue Funktionen nutzen

```yaml
# Einfache Verwendung mit automatischem Config-Merging
trivy-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    # Template lädt automatisch trivy.template.yaml und merged mit lokaler trivy.yaml
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
