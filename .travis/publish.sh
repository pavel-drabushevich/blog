#!/bin/bash
TARGET_DIR=$(mktemp -d /tmp/$BLOG.XXXX)
rsync -rt --delete --exclude=".git" "public/" "${TARGET_DIR}/"

echo "Updating gh-pages branch"
cd $TARGET_DIR
git init
git config user.name "Travis-CI"
git config user.email "p.drobushevich@gmail.com"
git add .
git commit -m "Deploy to GitHub Pages"
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1
