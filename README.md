# Trivy Scanner Templates

Dieses Repository enthält wiederverwendbare GitLab CI/CD-Templates für Trivy-Sicherheitsscans.

## 📦 Verfügbare Templates

- **`trivy-scanning.template.yaml`** - ✅ **Empfohlenes** Haupttemplate für Trivy-Scans (Image + Filesystem + alle Scanner-Typen)
- **`config-checks.template.yaml`** - ⚠️ **DEPRECATED** - Nutze stattdessen `trivy-scanning.template.yaml`
- **`license-checks.template.yaml`** - ⚠️ **DEPRECATED** - Nutze stattdessen `trivy-scanning.template.yaml`
- **`security-checks.template.yaml`** - ⚠️ **DEPRECATED** - Nutze stattdessen `trivy-scanning.template.yaml`

### ⚠️ Migrationshinweise

**WICHTIG**: Die individuellen Template-Dateien (`config-checks`, `license-checks`, `security-checks`) sind jetzt **VERALTET**.

Bitte migriere zum neuen unified `trivy-scanning.template.yaml`, welches bietet:
- Bessere Plugin-Architektur
- Flexiblere Konfigurationsoptionen  
- Einheitlicher Scanning-Ansatz
- Zukunftssicheres Design

Die veralteten Templates zeigen Migrationsanleitungen bei der Verwendung an.

#### Ignore-Datei

Um eine trivyignore Datei im YAML-Format nutzen zu können, muss die Variable `TRIVY_IGNOREFILE` gesetzt sein 
und den korrekten Pfad relativ zum Repository-Root enthalten, da trivy YAML-Ignorefiles nicht automatisch lädt.  
Pfade im YAML-Ignorefile werden von trivy relativ zum Verzeichnis aus der `DIRECTORY` Variable interpretiert, 
eventuell müssen die Pfade angepasst werden.  
Vergleiche dazu die Pfade in der Fehlertabelle mit denen im Ignore-File.

## 🚀 Verwendung

### Einbindung in GitLab CI/CD

Binde die Templates in deine `.gitlab-ci.yml` ein:

```yaml
include:
  - remote: 'https://github.com/ambient-innovation/gitlab-trivy-codequality-template/releases/download/v26.03.04.0/trivy-scanning.template.yaml'

stages:
  - test

# Verwende das Template
trivy-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    PLUGIN_SEVERITY: "HIGH,CRITICAL"
```

### Template-Konfiguration

Das Haupttemplate `trivy-scanning.template.yaml` unterstützt folgende Variablen:

#### Grundkonfiguration
- `IMAGE`: Docker-Image das gescannt werden soll (optional)
- `DIRECTORY`: Verzeichnis für Filesystem-Scan (Standard: "./")
- `FILENAME`: Name der CodeQuality-Ausgabedatei (Standard: "gl-codeclimate-$CI_JOB_NAME_SLUG.json")

#### Trivy-Konfiguration (NEU! 🎉)
- `TRIVY_CONFIG_MERGE`: Aktiviert/deaktiviert das Merging von Konfigurationsdateien (Standard: "true")
- `TRIVY_TEMPLATE_CONFIG_URL`: URL zur Template-Konfigurationsdatei (Standard: GitHub Repository)
- `LOCAL_TRIVY_CONFIG`: Pfad zur lokalen Trivy-Konfiguration (Standard: "trivy.yaml")
- `MERGED_TRIVY_CONFIG`: Pfad zur zusammengeführten Konfigurationsdatei

Das Template lädt automatisch eine `trivy.default.yaml` vom Repository herunter und kombiniert sie mit einer lokalen `trivy.yaml` falls vorhanden. Die lokale Konfiguration überschreibt dabei die Template-Einstellungen.

#### Plugin-Optionen
- `PLUGIN_SEVERITY`: Severity-Level (z.B. "HIGH,CRITICAL")
- `PLUGIN_SEVERITY_LICENSE`: Severity für Lizenz-Issues
- `PLUGIN_SEVERITY_VULN`: Severity für Vulnerabilities
- `PLUGIN_SEVERITY_MISCONFIG`: Severity für Misconfigurations
- `PLUGIN_SEVERITY_SECRET`: Severity für Secrets
- `PLUGIN_PKG_TYPES`: Package-Typen die gescannt werden sollen
- `PLUGIN_DEBUG`: Debug-Modus aktivieren
- `PLUGIN_TABLE`: Tahellen-Ausgabe der Ergebnisse anzeigen

### Beispiel-Konfigurationen

#### Mit eigener Trivy-Konfiguration (🎯 Empfohlen)
```yaml
# 1. Lade die trivy.default.yaml herunter (einmalig):
# curl -o trivy.yaml https://github.com/ambient-innovation/gitlab-trivy-codequality-template/releases/download/v26.03.04.0/trivy.default.yaml

# 2. Passe trivy.yaml nach deinen Bedürfnissen an

# 3. Verwende das Template:
trivy-full-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    # Die lokale trivy.yaml wird automatisch mit der Template-Konfiguration gemerged
```

#### Einfacher Scan ohne lokale Konfiguration
```yaml
trivy-simple-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    PLUGIN_SEVERITY: "HIGH,CRITICAL"
```

#### Konfigurationsmerging deaktivieren
```yaml
trivy-no-merge:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    TRIVY_CONFIG_MERGE: "false"  # Deaktiviert das Config-Merging
    PLUGIN_SEVERITY: "HIGH,CRITICAL"
```

#### Nur Image-Scan
```yaml
trivy-image-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "registry.example.com/my-app:$CI_COMMIT_SHA"
    PLUGIN_SEVERITY: "HIGH,CRITICAL"
```

#### Nur Filesystem-Scan
```yaml
trivy-fs-scan:
  extends: .trivy_scanning
  variables:
    DIRECTORY: "./src"
    PLUGIN_SEVERITY: "MEDIUM,HIGH,CRITICAL"
```

#### Nur Konfigurationsprüfungen (⚠️ehemals config-checks - nicht empfohlen ⚠️)
```yaml
trivy-config-scan:
  extends: .trivy_scanning
  variables:
    DIRECTORY: "./"
    PLUGIN_SEVERITY_MISCONFIG: "MEDIUM,HIGH,CRITICAL,UNKNOWN"
    PLUGIN_PKG_TYPES_MISCONFIG: "all"
```

#### Nur Lizenzprüfungen (⚠️ehemals license-checks - nicht empfohlen ⚠️)
```yaml
trivy-license-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    PLUGIN_SEVERITY_LICENSE: "HIGH,CRITICAL,UNKNOWN"
    PLUGIN_PKG_TYPES_LICENSE: "library,os"
```

#### Nur Sicherheitsprüfungen (⚠️ehemals security-checks - nicht empfohlen ⚠️)
```yaml
trivy-security-scan:
  extends: .trivy_scanning
  variables:
    IMAGE: "my-app:latest"
    DIRECTORY: "./"
    PLUGIN_SEVERITY_VULN: "HIGH,CRITICAL"
    PLUGIN_SEVERITY_MISCONFIG: "HIGH,CRITICAL"
    PLUGIN_PKG_TYPES_VULN: "os,library"
```

## 🔄 Versionierung

Dieses Projekt verwendet Calendar Versioning (CalVer) im Format `YY.MM.DD.MICRO`:

- **YY**: Jahr (z.B. 24 für 2024)
- **MM**: Monat (01-12)
- **DD**: Tag (01-31)
- **MICRO**: Tagesversion (0, 1, 2, ...)

### 🎯 Versionskonsistenz

**Wichtig**: Jedes Release stellt sicher, dass alle Template-Dateien konsistent sind:

- Das `trivy-scanning.template.yaml` eines Releases referenziert **immer** die `trivy.default.yaml` aus **demselben Release**
- Keine Abhängigkeiten zu `main` Branch Dateien in Released Templates
- Garantierte Kompatibilität zwischen Template und Konfigurationsdateien

```yaml
# ✅ Empfohlen: Spezifische Version verwenden
include:
  - remote: 'https://github.com/ambient-innovation/gitlab-trivy-codequality-template/releases/download/v26.03.04.0/trivy-scanning.template.yaml'
```

### Automatische Releases

Releases werden automatisch erstellt wenn:
- Änderungen an Template-Dateien gepusht werden
- Manuell über GitHub Actions ausgelöst wird

### Neueste Version verwenden

Die neueste Version findest du unter [Releases](../../releases/latest).


## 🛠️ Entwicklung

### Release Notes System

Dieses Projekt verwendet ein automatisiertes Release Notes System:

- **📝 CHANGELOG.md** - Alle Änderungen werden im `[Unreleased]` Abschnitt dokumentiert
- **🤖 Automatische Extraktion** - Release Notes werden automatisch aus dem Changelog generiert
- **🔄 Auto-Update** - Nach einem Release wird das Changelog für die nächste Version vorbereitet

Siehe [CONTRIBUTING.md](CONTRIBUTING.md) für Details zum Workflow.

### Lokales Testen

1. Repository klonen
2. Änderungen an Templates vornehmen
3. **Wichtig**: Änderungen in `CHANGELOG.md` dokumentieren
4. Commit und Push löst automatisch neues Release aus

### Manuelles Release

Ein Release kann manuell über GitHub Actions ausgelöst werden:

1. Gehe zu "Actions" → "Create Release with CalVer"
2. Klicke auf "Run workflow"
3. Wähle den Branch und setze "Force create release" falls nötig

## 📋 Anforderungen

- GitLab CI/CD
- Trivy Scanner (wird automatisch installiert)
- `jq` für JSON-Verarbeitung (wird automatisch installiert)

## 🤝 Beitragen

1. Fork das Repository
2. Erstelle einen Feature-Branch
3. Committe deine Änderungen
4. Erstelle einen Pull Request

## 📄 Lizenz

Dieses Projekt steht unter der Apache License 2.0 - siehe [LICENSE](LICENSE) für Details.

## 🔗 Links

- [Trivy Documentation](https://aquasecurity.github.io/trivy/)
- [GitLab CI/CD Templates](https://docs.gitlab.com/ee/ci/yaml/includes.html)
- [Trivy GitLab CodeQuality Plugin](https://github.com/ambient-innovation/trivy-plugin-gitlab-codequality)
