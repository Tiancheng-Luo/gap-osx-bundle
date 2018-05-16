#!/bin/sh -ex

GAP_VERSION=`cat $(BASEDIR)/GAP/VERSION`
VOLUME="GAP_${GAP_VERSION}"
TMP_DMG="TEMP.dmg"
DMG="$VOLUME.dmg"


# Create fresh empty dmg
rm -f "$TMP_DMG"
hdiutil create -size 2500m -fs HFS+ -volname "$VOLUME" "$TMP_DMG"


# Mount it, and parse the output for the mount path
mount_point=`hdiutil attach -plist "$TMP_DMG" \
  | tr -d "\n\r" \
  | /usr/bin/sed -E 's|.*<key>mount-point</key>[[:space:]]*<string>([^<]*)</string>.*|\1|'`

echo "Mount point: $mount_point"
VOLUME_DIR=`basename "$mount_point"`

# Setup icon
cp meta/VolumeIcon.icns "$mount_point/.VolumeIcon.icns"
SetFile -a C "$mount_point"

# Setup background
#mkdir -p "$mount_point/.background"
#cp meta/background.jpg "$mount_point/.background/background.jpg"

# Copy files

cp -R ../GAP.app "$mount_point"
cp meta/README "$mount_point"
cp meta/LICENSE "$mount_point"

# Set window position, view style, icon positions etc.
osascript << EOF
tell application "Finder"
	tell disk "$VOLUME_DIR"
		open

		tell container window
			set current view to icon view
			set toolbar visible to false
			set statusbar visible to false
			set bounds to {200, 100, 700, 400}
		end tell

		-- Adjust Icon & Text Sizes
		set icon size of the icon view options of container window to 72
		set text size of the icon view options of container window to 12

		-- Set Background Image
		--set background picture of the icon view options of container window to file ".background:background.jpg"

		-- Update Icon Positions
		set arrangement of the icon view options of container window to not arranged
		set position of item "GAP.app" of container window to {250, 60}
		set position of item "README" of container window to {110, 190}
		set position of item "LICENSE" of container window to {380, 190}

		close
		open

		update without registering applications
		--delay 3
		--close
		eject
	end tell
end tell
EOF

# Convert it into a compressed diskimage
rm -f "$DMG"
hdiutil convert "$TMP_DMG" -quiet -format UDZO -imagekey zlib-level=9 -o "$DMG"
rm -f "$TMP_DMG"
