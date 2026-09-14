# SSH Key Setup and TortoiseGit Configuration

## 1. Create an SSH key

Open PowerShell and run:

```powershell
ssh-keygen -t ed25519 -C "your_email@example.com"
```

When prompted for the file location, press **Enter** to use the default:

```text
C:\Users\<username>\.ssh\id_ed25519
```

You may optionally set a passphrase.

This creates:

```text
C:\Users\<username>\.ssh\id_ed25519
C:\Users\<username>\.ssh\id_ed25519.pub
```

- `id_ed25519` is the **private key**. Keep it secret.
- `id_ed25519.pub` is the **public key**. This is the key you can add to GitHub, GitLab, or your Git server.

To display the public key:

```powershell
Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"
```

Copy the entire line and add it to your Git hosting account/server.

## 2. Verify OpenSSH works

Check that Windows OpenSSH is available:

```powershell
where.exe ssh
```

You should normally see:

```text
C:\Windows\System32\OpenSSH\ssh.exe
```

Test the SSH connection. For GitHub:

```powershell
ssh -T git@github.com
```

If your Git server is different, replace `git@github.com` with the appropriate SSH address.

## 3. Configure TortoiseGit to use OpenSSH

Open:

**Right-click a folder → TortoiseGit → Settings**

Go to:

**Network**

Find **SSH client** and set it to:

```text
ssh.exe
```

Using OpenSSH allows TortoiseGit to use the normal Windows OpenSSH configuration and keys, including:

```text
C:\Users\<username>\.ssh\id_ed25519
```

You do **not** need to convert the key to `.ppk` when using OpenSSH.

## 4. Clone using SSH

In TortoiseGit, choose:

**TortoiseGit → Clone...**

Use an SSH repository URL such as:

```text
git@github.com:username/repository.git
```

TortoiseGit should then use the OpenSSH key from:

```text
C:\Users\<username>\.ssh\id_ed25519
```

## Notes

- Never share `id_ed25519`.
- It is safe to share `id_ed25519.pub`.
- Keep the private key backed up securely if it is important to your accounts.
- If you already have an existing `id_ed25519` key, do not overwrite it unless you intend to create a new identity.
