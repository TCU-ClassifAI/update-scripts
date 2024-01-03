# update-scripts
This has the update scripts that will be executed on a cronjob

The cronjob:
*/5 * * * * /home/web/deploy.sh >> /home/web/deploy.log 2>&1

You can access this via sudo crontab -l or -e
