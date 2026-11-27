#!/bin/sh

# Install Note Block Studio's AppImage metadata into an existing AppDir.

set -eu

nbs_carriage_return=$(printf '\r')

nbs_usage() {
	printf '%s\n' "Usage: $0 APPDIR [PAYLOAD_PATH_RELATIVE_TO_APPDIR]" >&2
	exit 2
}

[ "$#" -ge 1 ] && [ "$#" -le 2 ] || nbs_usage

nbs_tool_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
nbs_appdir_input=$1

[ -d "$nbs_appdir_input" ] || {
	printf '%s\n' "AppDir does not exist: $nbs_appdir_input" >&2
	exit 1
}
nbs_appdir=$(CDPATH= cd -- "$nbs_appdir_input" && pwd)

if [ "$#" -eq 2 ]; then
	nbs_payload_relative=$2
elif [ -f "$nbs_appdir/AppRun" ] && grep -q '^# NBS_APPIMAGE_WRAPPER=1$' "$nbs_appdir/AppRun"; then
	[ -r "$nbs_appdir/usr/lib/opennbs/payload-path" ] || {
		printf '%s\n' "The existing NBS AppRun wrapper has no payload record." >&2
		exit 1
	}
	IFS= read -r nbs_payload_relative <"$nbs_appdir/usr/lib/opennbs/payload-path"
elif [ -e "$nbs_appdir/AppRun" ]; then
	nbs_original_apprun=AppRun.nbs-original
	[ -x "$nbs_appdir/AppRun" ] || {
		printf '%s\n' "Existing AppRun is not executable: $nbs_appdir/AppRun" >&2
		exit 1
	}
	[ ! -e "$nbs_appdir/$nbs_original_apprun" ] || {
		printf '%s\n' "Refusing to overwrite existing $nbs_appdir/$nbs_original_apprun" >&2
		exit 1
	}
	mv "$nbs_appdir/AppRun" "$nbs_appdir/$nbs_original_apprun"
	nbs_payload_relative=$nbs_original_apprun
else
	printf '%s\n' "No existing AppRun was found; provide the payload path explicitly." >&2
	nbs_usage
fi

case "/$nbs_payload_relative/" in
	"//"|*"/../"*|*"/./"*|*"
"*|*"$nbs_carriage_return"*)
		printf '%s\n' "Payload path must be a non-empty normalized relative path." >&2
		exit 1
		;;
esac
case "$nbs_payload_relative" in
	/*)
		printf '%s\n' "Payload path must be relative to the AppDir." >&2
		exit 1
		;;
esac

[ -x "$nbs_appdir/$nbs_payload_relative" ] || {
	printf '%s\n' "Payload is not executable: $nbs_appdir/$nbs_payload_relative" >&2
	exit 1
}

for nbs_media_tool in ffmpeg ffprobe; do
	nbs_media_tool_path=$nbs_appdir/usr/bin/assets/$nbs_media_tool
	if [ -e "$nbs_media_tool_path" ]; then
		chmod 0755 "$nbs_media_tool_path"
	fi
done

mkdir -p \
	"$nbs_appdir/usr/lib/opennbs" \
	"$nbs_appdir/usr/share/applications" \
	"$nbs_appdir/usr/share/icons/hicolor/64x64/apps" \
	"$nbs_appdir/usr/share/mime/packages"

# AppImage permits one desktop entry at the AppDir root. Preserve any entry
# produced by an earlier packaging step, then install the NBS entry below.
nbs_desktop_backup_dir=$nbs_appdir/usr/lib/opennbs/original-desktop-entries
for nbs_root_desktop in "$nbs_appdir"/*.desktop; do
	[ -f "$nbs_root_desktop" ] || [ -L "$nbs_root_desktop" ] || continue
	[ "$(basename -- "$nbs_root_desktop")" = "org.opennbs.onbs.desktop" ] && continue
	mkdir -p "$nbs_desktop_backup_dir"
	nbs_desktop_backup=$nbs_desktop_backup_dir/$(basename -- "$nbs_root_desktop")
	[ ! -e "$nbs_desktop_backup" ] && [ ! -L "$nbs_desktop_backup" ] || {
		printf '%s\n' "Refusing to overwrite desktop-entry backup: $nbs_desktop_backup" >&2
		exit 1
	}
	mv -- "$nbs_root_desktop" "$nbs_desktop_backup"
done

cp "$nbs_tool_dir/AppRun" "$nbs_appdir/AppRun"
cp "$nbs_tool_dir/org.opennbs.onbs.desktop" \
	"$nbs_appdir/usr/share/applications/org.opennbs.onbs.desktop"
cp "$nbs_tool_dir/opennbs-nbs.xml" \
	"$nbs_appdir/usr/share/mime/packages/opennbs-nbs.xml"
cp "$nbs_tool_dir/org.opennbs.onbs.png" \
	"$nbs_appdir/usr/share/icons/hicolor/64x64/apps/org.opennbs.onbs.png"

printf '%s\n' "$nbs_payload_relative" >"$nbs_appdir/usr/lib/opennbs/payload-path"
chmod 0755 "$nbs_appdir/AppRun"
chmod 0644 \
	"$nbs_appdir/usr/lib/opennbs/payload-path" \
	"$nbs_appdir/usr/share/applications/org.opennbs.onbs.desktop" \
	"$nbs_appdir/usr/share/icons/hicolor/64x64/apps/org.opennbs.onbs.png" \
	"$nbs_appdir/usr/share/mime/packages/opennbs-nbs.xml"

ln -sfn usr/share/applications/org.opennbs.onbs.desktop \
	"$nbs_appdir/org.opennbs.onbs.desktop"
ln -sfn usr/share/icons/hicolor/64x64/apps/org.opennbs.onbs.png \
	"$nbs_appdir/org.opennbs.onbs.png"
ln -sfn org.opennbs.onbs.png "$nbs_appdir/.DirIcon"

printf '%s\n' "Prepared AppDir: $nbs_appdir"
