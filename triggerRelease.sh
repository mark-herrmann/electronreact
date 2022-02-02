#!/bin/bash

####  triggerRelease.sh ####################################
#                                                          #
# tags the last commit and triggers release                #
# author: Mark Herrmann                                    #
#                                                          #
# usage: triggerRelease.sh                                 #
#                                                          #
############################################################

# get version number
version=$(grep -e "^  \"version\"" ./package.json | cut -d'"' -f4)

# get message of last commit
message=$(git log -1 --pretty=%B)

# create commit to tag it
git commit --allow-empty --only -m "$message"

# tag this version (delete already existing tag before)
# disable spellcheck for missing quotes. $version will never contain spaces
# shellcheck disable=SC2086
git tag -d v$version 2>/dev/null
# shellcheck disable=SC2086
git push --delete origin v$version 2>/dev/null
# shellcheck disable=SC2086
git tag -a v$version -m "tagged '$message' with v$version"

# push tag to trigger release
git push && git push --tags
