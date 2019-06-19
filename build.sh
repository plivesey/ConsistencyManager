#!/bin/sh
# Builds all targets and runs tests.

DERIVED_DATA=${1:-/tmp/ConsistencyManager}
echo "Derived data location: $DERIVED_DATA";

set -o pipefail &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean test \
    -project ConsistencyManager.xcodeproj \
    -scheme ConsistencyManager \
    -sdk macosx \
    -derivedDataPath $DERIVED_DATA \
    | tee build.log \
    | xcpretty &&
rm -rf $DERIVED_DATA &&
time xcodebuild clean build \
    -project ConsistencyManager.xcodeproj \
    -scheme ConsistencyManager \
    -sdk iphonesimulator \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.4' \
    -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
    -destination 'platform=iOS Simulator,name=iPhone 7,OS=10.1' \
    -destination 'platform=iOS Simulator,name=iPhone 8,OS=11.3' \
    -destination 'platform=iOS Simulator,name=iPhone XS Max,OS=12.2' \
    | tee build.log \
    | xcpretty &&
rm -rf $DERIVED_DATA &&
    time xcodebuild clean build \
    -project ConsistencyManager.xcodeproj \
    -scheme ConsistencyManager \
    -sdk appletvsimulator \
    -derivedDataPath $DERIVED_DATA \
    -destination 'platform=tvOS Simulator,name=Apple TV,OS=12.2' \
    | tee build.log \
    | xcpretty &&
cat build.log

