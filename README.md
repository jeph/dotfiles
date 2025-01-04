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

Next, create a `chezmoi.toml` file in `~/.config/chezmoi/`

```sh
touch ~/.config/chezmoi/chezmoi.toml
```

Add the following data values to the `chezmoi.toml` file:

```toml
[data]
    git_name = "git name to use"
    git_email = "git email to use"
    git_signing_key = "signing key to use"
```

Finally, run the following command to apply the dotfiles:

```sh
chezmoi init --apply Jeph
```

**^ This will overwrite existing files so make sure to take a backup
if there are any with content you care about.**

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

Use the `add` command to add a new file to chezmoi:

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
