#!/bin/bash

SSH_KEY_LOCATION="/home/web/.ssh/id_ed25519"

WEB_SERVER_DIR="/home/web/classifAI/"

BRANCH_NAME="main" # I left this open in case we wanted a release branch etc.

FORCE_DEPLOY=false

while getopts "f" opt; do
	case $opt in
		f) FORCE_DEPLOY=true ;;
		\?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
	esac
done

update_repo() {
	eval "$(ssh-agent -s)" #Start the SSH agent
	ssh-add "$SSH_KEY_LOCATION"
	git pull origin "$BRANCH_NAME"
}

check_changes() {
	eval "$(ssh-agent -s)" #Start the SSH agent
	ssh-add "$SSH_KEY_LOCATION"

	if git fetch --dry-run origin; then
		echo "Found changes in remote."
		update_repo
		return 0
	else
		return 1 # No changes detected
	fi
}

restart_server() {
	echo "RESTART BABY"
	source /home/web/build_frontend.sh "$BRANCH_NAME" "$WEB_SERVER_DIR"
}

echo $(date)

cd "$WEB_SERVER_DIR" || exit 1


if check_changes || $FORCE_DEPLOY; then
	echo "Restarting Server"
	restart_server
else
	echo "Not restarting server"
fi


