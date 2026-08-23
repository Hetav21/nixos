---
description: "Comprehensive security audit for any codebase"
argument-hint: "[scope: full|secrets|patterns|deps|config]"
agent: "Sisyphus"
---

# Security Audit Command

You are a security auditor performing a comprehensive security review of this codebase. Analyze systematically and report findings with severity levels.

## Scan Configuration

**Scope:** $ARGUMENTS (default: `full`)
- `full` - Complete security audit (all categories)
- `secrets` - Secret/credential detection only
- `patterns` - Dangerous code patterns only
- `deps` - Dependency vulnerabilities only
- `config` - Configuration security only

## Output Format

For each finding, report:
```
[SEVERITY] Category: Brief description
  File: path/to/file:line
  Issue: Detailed explanation
  Risk: What could go wrong
  Fix: How to remediate
```

Severity levels: `🔴 CRITICAL`, `🟠 HIGH`, `🟡 MEDIUM`, `🔵 LOW`, `⚪ INFO`

---

## Phase 1: Project Detection

First, identify the project type to tailor the scan:

1. **Detect package managers & lockfiles:**
   - `package.json` / `package-lock.json` / `yarn.lock` / `pnpm-lock.yaml` → Node.js
   - `requirements.txt` / `Pipfile` / `pyproject.toml` / `poetry.lock` → Python
   - `Cargo.toml` / `Cargo.lock` → Rust
   - `go.mod` / `go.sum` → Go
   - `flake.nix` / `flake.lock` → Nix
   - `Gemfile` / `Gemfile.lock` → Ruby
   - `composer.json` → PHP
   - `pom.xml` / `build.gradle` → Java/Kotlin

2. **Detect frameworks:**
   - Next.js, React, Vue, Angular, Svelte
   - Django, Flask, FastAPI
   - Express, NestJS, Fastify
   - Rails, Laravel

3. **Detect infrastructure:**
   - Docker (Dockerfile, docker-compose.yml)
   - Kubernetes (*.yaml with apiVersion)
   - Terraform (*.tf)
   - AWS CDK, Pulumi

Report detected stack before proceeding.

---

## Phase 2: Secret Detection

### 2.1 Regex Patterns for Secrets

Search for these patterns:

**API Keys & Tokens:**
```regex
# Generic API keys
(?i)(api[_-]?key|apikey|api[_-]?secret)\s*[:=]\s*["']?[a-zA-Z0-9_\-]{20,}["']?

# AWS
(?i)(AKIA|ABIA|ACCA|ASIA)[0-9A-Z]{16}
(?i)aws[_-]?(secret[_-]?access[_-]?key|access[_-]?key[_-]?id)\s*[:=]\s*["']?[A-Za-z0-9/+=]{40}["']?

# GitHub
gh[ps]_[a-zA-Z0-9]{36}
github_pat_[a-zA-Z0-9]{22}_[a-zA-Z0-9]{59}

# GitLab
glpat-[a-zA-Z0-9\-_]{20,}

# Slack
xox[baprs]-[0-9]{10,13}-[0-9]{10,13}[a-zA-Z0-9-]*

# Stripe
sk_live_[a-zA-Z0-9]{24,}
rk_live_[a-zA-Z0-9]{24,}

# JWT (check if hardcoded)
eyJ[a-zA-Z0-9_-]*\.eyJ[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*

# Private Keys
-----BEGIN (RSA|DSA|EC|OPENSSH|PGP) PRIVATE KEY-----
-----BEGIN PRIVATE KEY-----

# Generic secrets
(?i)(password|passwd|pwd|secret|token|bearer|auth[_-]?token)\s*[:=]\s*["'][^"']{8,}["']

# Database URLs with credentials
(?i)(mysql|postgres|mongodb|redis|amqp)://[^:]+:[^@]+@

# Google
AIza[0-9A-Za-z\-_]{35}

# Firebase
AAAA[A-Za-z0-9_-]{7}:[A-Za-z0-9_-]{140}

# Twilio
SK[a-f0-9]{32}

# SendGrid
SG\.[a-zA-Z0-9_-]{22}\.[a-zA-Z0-9_-]{43}

# npm
npm_[a-zA-Z0-9]{36}

# Discord
[MN][A-Za-z\d]{23,}\.[\w-]{6}\.[\w-]{27}

# OpenAI
sk-[a-zA-Z0-9]{48}

# Anthropic
sk-ant-[a-zA-Z0-9\-_]{95}
```

### 2.2 Files to Check

**High-risk locations:**
- `.env`, `.env.*`, `*.env`
- `config/`, `settings/`, `secrets/`
- `*.config.js`, `*.config.ts`
- `.npmrc`, `.pypirc`, `.netrc`
- `docker-compose*.yml`
- `application.properties`, `application.yml`
- Jupyter notebooks (`*.ipynb`) - check cell outputs

**Exclusions (reduce false positives):**
- `node_modules/`, `vendor/`, `.venv/`, `venv/`
- `*.lock`, `*.min.js`, `*.min.css`
- `.git/`
- Binary files

### 2.3 Git History Check

If git repository, check for secrets in history:
```bash
# If gitleaks available
gitleaks detect --source . --verbose 2>/dev/null

# Fallback: check recently added sensitive files
git log --diff-filter=A --name-only --pretty="" -- "*.env" "*.pem" "*.key" "*secret*" "*credential*" | head -20
```

### 2.4 Encrypted Secrets Verification

Check if secret management is properly configured:
- **sops/sops-nix**: Verify `.sops.yaml` exists and secret files are encrypted
- **git-crypt**: Check `.gitattributes` for git-crypt patterns
- **doppler/vault**: Check for config files referencing secret managers

---

## Phase 3: Dangerous Code Patterns

### 3.1 Injection Vulnerabilities

**Command Injection:**
```regex
(?i)(exec|system|popen|subprocess\.call|child_process\.exec|shell_exec)\s*\([^)]*\$
```

**JavaScript/TypeScript:**
```regex
eval\s*\(
new\s+Function\s*\(
setTimeout\s*\(\s*["'`]
setInterval\s*\(\s*["'`]
\.innerHTML\s*=
dangerouslySetInnerHTML
```

**Python:**
```regex
(?<!#.*)eval\s*\(
(?<!#.*)exec\s*\(
pickle\.load
yaml\.load\([^)]*\)(?!.*Loader)
subprocess\..*shell\s*=\s*True
os\.system\s*\(
```

**SQL Injection:**
```regex
["']\s*\+\s*[a-zA-Z_]+\s*\+\s*["']
f["'].*\{.*\}.*(?:SELECT|INSERT|UPDATE|DELETE)
```

### 3.2 Authentication & Authorization

```regex
(?i)(verify|validate|check|require).*=\s*(false|False|0|nil|null|undefined)
(?i)ssl[_-]?verify\s*[:=]\s*(false|False|0)
(?i)insecure[_-]?skip[_-]?verify\s*[:=]\s*true
jwt\.decode\([^)]*verify\s*=\s*False
```

### 3.3 Cryptography Issues

```regex
(?i)(md5|sha1|des|rc4)\s*\(
(?i)hashlib\.(md5|sha1)\s*\(
Math\.random\s*\(
random\.random\s*\(
```

### 3.4 Path Traversal

```regex
(?i)(readFile|writeFile|open|fopen)\s*\([^)]*\+
\.\.\/
\.\.\\
path\.join\([^)]*req\.(params|query|body)
```

---

## Phase 4: Dependency Security

### 4.1 Check for Known Vulnerabilities

Run appropriate scanner based on detected ecosystem:

**Node.js:**
```bash
npm audit --json 2>/dev/null || yarn audit --json 2>/dev/null || pnpm audit --json 2>/dev/null
```

**Python:**
```bash
pip-audit --format json 2>/dev/null || safety check --json 2>/dev/null
```

**Rust:**
```bash
cargo audit --json 2>/dev/null
```

**Go:**
```bash
govulncheck ./... 2>/dev/null
```

**General (if trivy available):**
```bash
trivy fs --security-checks vuln --format json . 2>/dev/null
```

### 4.2 Outdated Dependencies

Check for significantly outdated packages:
```bash
npm outdated --json 2>/dev/null
pip list --outdated --format json 2>/dev/null
```

---

## Phase 5: Configuration Security

### 5.1 Docker Security

```regex
USER\s+root
--privileged
EXPOSE\s+(22|3389|5432|3306|27017|6379)
COPY.*\.(env|pem|key|secret)
FROM\s+[^:]+:latest
```

### 5.2 Kubernetes/Helm

```regex
privileged:\s*true
runAsUser:\s*0
runAsNonRoot:\s*false
hostNetwork:\s*true
hostPID:\s*true
```

### 5.3 CI/CD Configuration

Check `.github/workflows/`, `.gitlab-ci.yml`, `Jenkinsfile`:
```regex
echo.*\$\{\{.*secrets
curl.*\|\s*(bash|sh)
wget.*\|\s*(bash|sh)
pull_request_target:
```

### 5.4 CORS & Security Headers

```regex
Access-Control-Allow-Origin.*\*
cors\(\s*\)
cors\(\{[^}]*origin:\s*["']\*["']
```

---

## Phase 6: File Permission Patterns

```regex
chmod\s+777
chmod\s+666
mode:\s*["']?0?777["']?
mode:\s*["']?0?666["']?
```

---

## Phase 7: Generate Report

After scanning all phases, generate a structured report:

### Summary Statistics
- Total findings by severity
- Categories with most issues
- Files with most issues

### Prioritized Findings
1. 🔴 **CRITICAL** - Immediate action required (exposed secrets, RCE vulnerabilities)
2. 🟠 **HIGH** - Address within 24 hours (authentication bypasses, SQL injection)
3. 🟡 **MEDIUM** - Address within sprint (weak crypto, missing headers)
4. 🔵 **LOW** - Address when convenient (outdated deps, minor config issues)
5. ⚪ **INFO** - Best practice recommendations

### Quick Wins
List issues that can be fixed in < 5 minutes with high impact.

### Recommended Tools
Suggest installing security scanners if not present:
- `gitleaks` - Secret scanning
- `trivy` - Comprehensive vulnerability scanner
- `semgrep` - Static analysis
- Language-specific: `npm audit`, `pip-audit`, `cargo-audit`

---

## Execution Strategy

1. **Use serena tools** for AST-aware pattern matching
2. **Use grep/ripgrep** for fast regex searches
3. **Use bash** for external scanner integration
4. **Fire parallel explore agents** for complex pattern analysis
5. **Report false positives** - patterns may match test data or docs

## Important Notes

- **Never auto-fix secrets** - require human verification
- **Check .gitignore** - warn if sensitive patterns are NOT ignored
- **Respect scope** - only scan what user requested
- **Be thorough but efficient** - prioritize high-impact findings
