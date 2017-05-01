#!/bin/sh

# chmod +x deploy.sh // to convert as executable
# ./deploy // to run

#script _scripts/publish_toghpages.sh // below two lines are relavant if this is commented out
#DIR=$(dirname "$0")
#cd $DIR/..

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add public -B gh-pages origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd out
git init
git config user.name "Travis-CI"
git config user.email "p.drobushevich@gmail.com"
git add .
git commit -m "Deploy to GitHub Pages"
git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2>&1
