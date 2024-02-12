#!/bin/bash

SSH_KEY_LOCATION="/home/web/.ssh/id_ed25519"
WEB_SERVER_DIR="/home/web/classifAI/"
BRANCH_NAME="main"
FORCE_DEPLOY=false

# Parse options
while getopts "f" opt; do
	case $opt in
		f) FORCE_DEPLOY=true ;;
		\?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
	esac
done

# Start the SSH agent and add the SSH key
eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY_LOCATION"

update_repo() {
	git pull origin "$BRANCH_NAME"
}

check_changes() {
	# Fetch the latest changes from the remote without merging them
	git fetch origin "$BRANCH_NAME"
	
	# Check if there are changes by comparing the HEADs
	local LOCAL_HEAD=$(git rev-parse HEAD)
	local REMOTE_HEAD=$(git rev-parse "origin/$BRANCH_NAME")
	
	if [ "$LOCAL_HEAD" != "$REMOTE_HEAD" ]; then
		echo "Found changes in remote."
		update_repo
		return 0
	else
		echo "No changes detected."
		return 1
	fi
}

restart_server() {
	echo "Restarting server..."
	source /home/web/update-scripts/build_frontend.sh "$BRANCH_NAME" "$WEB_SERVER_DIR"
	source /home/web/update-scripts/build_mongo.sh
	source /home/web/update-scripts/build_backend.sh
}

echo "$(date)"
cd "$WEB_SERVER_DIR" || exit 1

if check_changes || $FORCE_DEPLOY; then
	restart_server
else
	echo "Not restarting server."
fi

# Kill the SSH agent
eval "$(ssh-agent -k)"
