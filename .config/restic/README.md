# Restic config files

These are my files for backups. I use restic and rclone to automatically save
periodic backups in a remote cloud service.

## Systemd services

For each restic repository a systemd user service is configured, as well as a
systemd timer to trigger the service periodically.

The config files for these systemd units are in the .config/systemd/user folder:

- restic@.service: service that uses restic to perform a backup on a repository.
- restic@.timer: trigger the corresponding backup service periodically.
- restic-prune@.service: service that prunes the repository file system.
- restic-prune@.timer: triggers the prune periodically.

These units must be activated with a parameter that specifies the repository
name:

```bash 
systemctl --user enable restic@repo-name.service
```

You can also manually run the service:

```bash 
systemctl --user start restic@repo-name.service
```


## Repository configuration

For each repository name the restic service expects several files in the 
.config/restic folder:

- repo-name.env: environment for the restic command. Should define the
variables:
    - RESTIC_PASSWORD_FILE (file that contains the password for the repository)
    - RESTIC_REPOSITORY
    - RETENTION_DAYS
    - RETENTION_WEEKS
    - RETENTION_MONTHS
    - RETENTION_YEARS
- repo-name.files: paths included in the backup
- repo-name.excludes: paths excluded from the backup

A convenient storage for the password would be in .config/restic/repo-name.pass.
These files are ignored by git in this repository.
