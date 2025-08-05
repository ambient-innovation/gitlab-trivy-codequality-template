# Contributing Guide

## 📝 Release Notes Management

Dieses Projekt verwendet ein automatisiertes Release Notes System basierend auf `CHANGELOG.md`.

### Wie man Änderungen dokumentiert

1. **Alle Änderungen** werden im `[Unreleased]` Abschnitt von `CHANGELOG.md` dokumentiert
2. **Beim Release** wird der `[Unreleased]` Abschnitt automatisch zur neuen Version
3. **Release Notes** werden automatisch aus dem Changelog generiert

### Changelog Kategorien

- **Added** - Neue Funktionen
- **Changed** - Änderungen an bestehenden Funktionen
- **Fixed** - Bugfixes
- **Deprecated** - Veraltete Funktionen (noch verfügbar)
- **Removed** - Entfernte Funktionen
- **Security** - Sicherheitsupdates

### Beispiel Workflow

```bash
# 1. Neue Funktion entwickeln
git checkout -b feature/config-merging

# 2. Änderungen im CHANGELOG.md dokumentieren
# Füge in [Unreleased] > Added hinzu:
# - Trivy configuration merging functionality

# 3. Code committen
git commit -m "feat: add trivy configuration merging"

# 4. CHANGELOG update committen
git commit -m "docs: update CHANGELOG.md for config merging feature"

# 5. Pull Request erstellen
# 6. Nach Merge triggert automatisch ein Release
```

### Release Prozess

1. **Push zu main/master** → Triggert GitHub Action
2. **CalVer Version** wird automatisch generiert (YY.MM.DD.MICRO)
3. **Release Notes** werden aus `[Unreleased]` extrahiert
4. **Templates** werden mit versionsspezifischen URLs vorbereitet
5. **GitHub Release** wird erstellt
6. **CHANGELOG.md** wird für nächste Version vorbereitet

### Manuelle Release Notes

Falls das automatische System versagt, werden Fallback Release Notes erstellt basierend auf Git Commits.

### Skripte

- `scripts/extract-release-notes.sh` - Extrahiert Release Notes aus CHANGELOG.md
- `scripts/update-changelog.sh` - Aktualisiert CHANGELOG.md nach einem Release

### Best Practices

- ✅ **Immer** Änderungen in CHANGELOG.md dokumentieren
- ✅ **Klare** und benutzerfreundliche Beschreibungen verwenden
- ✅ **Breaking Changes** deutlich kennzeichnen
- ❌ **Keine** technischen Details in Release Notes
- ❌ **Keine** internen Code-Änderungen dokumentieren (außer sie betreffen Benutzer)

### Beispiel CHANGELOG.md Eintrag

```markdown
## [Unreleased]

### Added
- Automatisches Merging von Trivy-Konfigurationsdateien
- Neue Umgebungsvariable `TRIVY_CONFIG_MERGE` für Config-Kontrolle
- Versionsspezifische Template-URLs in Releases

### Changed
- Templates zeigen jetzt Deprecation-Warnungen bei der Verwendung

### Deprecated
- `config-checks.template.yaml` - Nutze stattdessen `trivy-scanning.template.yaml`
```
