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
    git_tag
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
}

git_tag () {
    git tag -m "Release v$version" "v$version"
}

git_push () {
    git push --tags
}

main
