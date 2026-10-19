#!/bin/sh
# File scanner for smart-open (nvim quick open). Runs the normal `rg --files`
# scan, which respects .gitignore, then adds back the ignored files worth
# opening: loose gitignored files in tracked directories (.env, local.conf) and
# the contents of *small* gitignored directories (.vscode/). Large ignored
# directories (build/, a zephyr workspace's modules/) stay out — `--directory`
# collapses each to a single entry, which is dropped unless it's small.
rg "$@"

max_dir_files=20
git ls-files --others --ignored --exclude-standard --directory 2>/dev/null |
while IFS= read -r entry; do
	case "$entry" in
	*/)
		n=$(find "$entry" -type f -not -path '*/.git/*' 2>/dev/null | head -n $((max_dir_files + 1)) | wc -l)
		if [ "$n" -le "$max_dir_files" ]; then
			find "$entry" -type f -not -path '*/.git/*' 2>/dev/null
		fi
		;;
	*) printf '%s\n' "$entry" ;;
	esac
done
