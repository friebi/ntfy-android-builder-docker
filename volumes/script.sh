#!/bin/bash
sudo rm /volumes/builds/app-play-release-unsigned.apk
NTFY_ESCAPED_REPLACE=$(printf '%s\n' "$NTFY_APP_BASE_URL" | sed -e 's/[\/&]/\\&/g')
cd ntfy-android
git pull
cp /volumes/firebase/google-services.json app/google-services.json
sed -i "s/>https:\\/\\/ntfy.sh</>$NTFY_ESCAPED_REPLACE</" app/src/main/res/values/values.xml
./gradlew assemblePlayRelease
cp app/build/outputs/apk/play/release/app-play-release-unsigned.apk /volumes/builds
NTFY_VERSION=$(awk '/versionName / {gsub(/"/, "", $2); print $2}' app/build.gradle)
cd /volumes/builds
/home/circleci/android-sdk/build-tools/36.1.0-rc1/apksigner sign --out ntfy-release-${NTFY_VERSION}.apk\
  --ks /volumes/keystore/keystore.jks --ks-pass "pass:constrain-transpose5-fraction-virus-compacter" app-play-release-unsigned.apk
sudo chown $UID:$GID *
