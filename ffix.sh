##!/usr/bin/env bash

echo "Please enter your GitHub API token: "
read API_TOKEN

echo "Please enter your team's company/user name: "
read OWNER

echo "Please enter the name of your repo: "
read REPO

echo "Please enter the name of your base branch: "
read BRANCH

cp rules_template.xml /tmp/rules.xml
curl 'https://api.github.com/repos/${OWNER}/${REPO}/pulls?access_token=${API_TOKEN}' | grep "\"ref\": \"" | grep -v $BRANCH | sed 's/.*"ref": "//g' | sed 's/",//g' | xargs -n 1 git diff --name-only $BRANCH -0 | awk '!seen[$0]++' | sed 's/\(.*\)/<exclude-pattern>\1<\/exclude-pattern>/g' >> /tmp/rules.xml 
echo -n '</ruleset>' >> /tmp/rules.xml

phpcbf --standard=/tmp/rules.xml ./public/utils 
