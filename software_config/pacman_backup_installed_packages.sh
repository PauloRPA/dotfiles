filename=pkglistbackup.txt
touch /etc/pacman.d/hooks/backup_installed_packages.hook
cat > /etc/pacman.d/hooks/backup_installed_packages.hook << EOF
[Trigger]
Operation = Install
Operation = Remove
Type = Package
Target = *

[Action]
When = PostTransaction
Exec = /bin/sh -c "/usr/bin/pacman -Qqen > /home/$filename"
EOF
