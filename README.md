# dotfiles

This repository is used to manage my dotfiles and other configuration
files. It integrates with [chezmoi](https://www.chezmoi.io/) to
manage these files.

## Setting up a new machine

To set up a new machine, first install chezmoi:

```sh
brew install chezmoi
```

Other installation options can be found
[here](https://www.chezmoi.io/install/).

Next, run the following command to apply the dotfiles:

```sh
chezmoi init --apply Jeph
```

**^ This will overwrite existing files so make sure to take a backup
if there are any with content you care about.**

After applying, create a local git config at `~/.gitconfig.local` for
your machine-specific identity/signing settings (this file is not
managed by chezmoi):

```ini
[user]
    name = Your Name
    email = you@example.com
    signingkey = YOUR_SSH_SIGNING_KEY
[gpg]
    format = ssh
[gpg "ssh"]
    program = /Applications/1Password.app/Contents/MacOS/op-ssh-sign
[commit]
    gpgsign = true
```

Optional: create `~/.zshrc.local` for machine-specific shell config.
`~/.zshrc` sources it if it exists, and it is not managed by chezmoi.
(The `.local` suffix here just means “local overrides”; it’s unrelated to
the `~/.local/` directory.)

```sh
# ~/.zshrc.local
# Example:
# export PATH="/opt/homebrew/bin:$PATH"
```

Alternatively, if you want to see what changes chezmoi will make,
you can run:

```sh
chezmoi init Jeph # Initiate chezmoi without applying changes
chezmoi diff
```

If you are happy with the changes that chezmoi will make then run:

```sh
chezmoi apply -v
```

You can edit files using the edit command:

```sh
chezmoi edit $FILE
```

or you can simply edit the files directly. chezmoi stores the files
in `~/.local/share/chezmoi/` by default.

You can also use the following command to navigate to the chezmoi 
directory, but be aware that this will also open a new shell:

```sh
chezmoi cd
```

You can pull and apply the latest changes from your repo with:
```sh
chezmoi update -v
```

## Workflows

Use the `add` command to add a new file to chezmoi or an existing file's 
changes:

```sh
chezmoi add $FILE
```

Use the `apply` command to update the working files with the source
files:

```sh
chezmoi apply -v
```

As long as you already have initiated chezmoi and applied before,
chezmoi should warn you if there are any conflicts.

To resolve conflicts, you can use the `diff` command to see the
differences:

```sh
chezmoi diff
```

You can use the merge command to resolve the conflicts:

```sh
chezmoi merge $FILE
```
