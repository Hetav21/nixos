# Secrets Management

This directory contains encrypted secrets managed with [sops-nix](https://github.com/Mic92/sops-nix).

## Contents

- One encrypted `<secret>.yaml` file per secret
- `keys.asc` - GPG/age keys for decrypting secrets (gitignored — never committed)
- `secrets/default.nix` - sops-nix module declaring every secret

**Source of truth for the current inventory:** `secrets/default.nix`.

## How Secrets Work

All secrets are encrypted using sops (Secrets OPerationS). The encryption keys are stored in `keys.asc`. When NixOS builds your system, sops-nix automatically decrypts the secrets at runtime and makes them available to your system.

## Adding a New Secret

1. **Create the secret file** (if it doesn't exist):
   ```bash
   sops secrets/<name>.yaml
   ```
   
2. **Edit the secret**:
   ```yaml
   my_api_key: "your-secret-value-here"
   my_password: "another-secret"
   ```

3. **Add to `secrets/default.nix`** — mirror an existing entry (it is the source of truth):
   ```nix
   sops.secrets.<name> = {
     sopsFile = ./<name>.yaml;

     mode = "0440";
     owner = config.users.users.${settings.username}.name;
     group = config.users.users.${settings.username}.group;
   };
   ```

4. **Use in your configuration**:
   ```nix
   # The secret will be available at:
   config.sops.secrets.<name>.path
   # Usually: /run/secrets/<name>
   ```

## Editing Existing Secrets

To edit an existing secret:

```bash
sops secrets/<secret>.yaml
```

This will decrypt, open your editor, then re-encrypt the file.

## Key Management

### Generating New Keys

If you need to generate new keys:

```bash
# For age (recommended)
age-keygen -o ~/.config/sops/age/keys.txt

# For GPG
gpg --generate-key
```

### Backing Up Keys

**IMPORTANT**: Back up your `keys.asc` file securely! Without it, you cannot decrypt your secrets.

Store it in:
- A password manager
- An encrypted USB drive  
- A secure cloud backup (encrypted)

**Never commit unencrypted keys to git!**

## Security Best Practices

1. ✅ **DO**: Encrypt all sensitive data (API keys, passwords, tokens)
2. ✅ **DO**: Back up encryption keys separately from the repository
3. ✅ **DO**: Use different keys for different environments (personal/work)
4. ✅ **DO**: Rotate secrets periodically
5. ❌ **DON'T**: Commit unencrypted secrets to git
6. ❌ **DON'T**: Share encryption keys in plaintext
7. ❌ **DON'T**: Use the same secrets across multiple systems

## Troubleshooting

### "Failed to decrypt" errors

- Check that `keys.asc` exists and has the correct key
- Verify sops is installed: `nix-shell -p sops`
- Try decrypting manually: `sops -d secrets/<secret>.yaml`

### Permission denied accessing secrets

- Secrets are only readable by root and the specified owner
- Check the `owner` field in `default.nix`
- Secrets are available at `/run/secrets/`

## More Information

- [sops-nix documentation](https://github.com/Mic92/sops-nix)
- [sops documentation](https://github.com/mozilla/sops)
- [age encryption tool](https://github.com/FiloSottile/age)

