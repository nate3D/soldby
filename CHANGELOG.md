# Changelog

All notable changes to the SoldBy userscript will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.8.0] - 2026-03-02

### Changed
- Updated external dependency from openuserjs.org to reliable jsDelivr CDN for GM_config library
- Updated browser compatibility information (Firefox v148, Chrome v145)
- Improved code quality by standardizing variable declarations (const/let instead of var)

### Security
- Fixed security vulnerabilities by replacing manual JSON string concatenation with JSON.stringify()
- This prevents potential injection attacks if seller data contains malicious content

### Maintenance
- Modernized codebase to align with 2026 standards
- Updated README with current browser versions and compatibility information
- Added this CHANGELOG to track version history

## [1.7.2] - 2023-11-30

### Fixed
- Added new selector to find Amazon as seller after recent markup change

## Earlier versions

See git history for changes in earlier versions.
