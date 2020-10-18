#!/bin/sh

set -eu

if [ $# -ne 1 ]; then
    echo "Usage: ./tools/release.sh <version-number>"
    echo
    echo "The version will be added as a git tag and pushed to github"
    echo
    echo "Example: ./tools/release.sh 1.2.3"
    exit 1
fi

version=$1

main () {
    sanity_check
    patch_changelog
    patch_plugin_info
    git_commit_and_tag
    git_push
}

sanity_check () {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$current_branch" != "main" ]; then
        echo 'You need to be on the main branch to release'
        exit 1
    fi

    local unpushed_commits=$(git cherry)
    if [ "$unpushed_commits" != '' ]; then
        echo 'You have unpushed commits'
        exit 1
    fi

    grep -q UNRELEASED CHANGELOG.md \
        || (echo >&2 'No changes noted in CHANGELOG'; exit 1)

    set +e
    git diff-index --quiet --cached HEAD
    local has_staged_changes=$?
    git diff-files --quiet
    local has_unstaged_changes=$?
    set -e
    if [ $has_staged_changes -ne 0 -o $has_unstaged_changes -ne 0 ]; then
        echo >&2 "You have a dirty index, please stash or commit your changes before releasing"
        exit 1
    fi
}

patch_changelog() {
    # Doesn't use sed -i since it's not portable
    sed "s/UNRELEASED/$version - $(date -u +'%Y-%m-%d')/" CHANGELOG.md \
        > tmp-changelog
    mv tmp-changelog CHANGELOG.md
}

patch_plugin_info() {
    major=$(echo "$version" | cut -d . -f 1)
    minor=$(echo "$version" | cut -d . -f 2)
    patch=$(echo "$version" | cut -d . -f 3)
    # Doesn't use sed -i since it's not portable
    sed -E \
        -e "s/major = [0-9]+/major = $major/" \
        -e "s/minor = [0-9]+/minor = $minor/" \
        -e "s/revision = [0-9]+/revision = $patch/" \
        LiveStack.lrdevplugin/Info.lua \
        > tmp-info
    mv tmp-info LiveStack.lrdevplugin/Info.lua
}

git_commit_and_tag() {
    git add CHANGELOG.md LiveStack.lrdevplugin/Info.lua
    git commit -m "Release $version"
    git tag -m "Release v$version" "v$version"
}

git_push () {
    git push --tags
}

main
