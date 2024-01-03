#!/bin/bash
BRANCH_DEFAULT="main"
FILE_ROOT_DEFAULT="/var/www/classifai.tcu.edu/"
REPO_LOCATION_DEFAULT="/home/web/classifAI/frontend"

if [ $# -ge 1 ]; then
	BRANCH="$1"
else
	BRANCH="$BRANCH_DEFAULT"
fi

if [ $# -ge 2 ]; then
	REPO_LOCATION="$2"
else
	REPO_LOCATION="$REPO_LOCATION_DEFAULT"
fi

FILE_ROOT="$FILE_ROOT_DEFAULT"


echo "Building from $BRANCH"
cd "$REPO_LOCATION_DEFAULT"
git checkout "$BRANCH"

echo "Building app..."
npm install
npm run build

echo "Moving build contents to $FILE_ROOT"
rm -r "$FILE_ROOT"
mkdir "$FILE_ROOT"
mv build/* "$FILE_ROOT"

echo "Done."
