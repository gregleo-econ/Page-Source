#!/bin/bash
# Scriptacular - gitupdate.sh
# Compare SHA-1 between local and remote repositories, git pull + FF merge in local if they differ
# Copyright 2013 Christopher Simpkins
# MIT License

# Default to working directory
LOCAL_REPO="/root/Page-Source/"
# Default to git pull with FF merge in quiet mode
GIT_COMMAND="git pull --quiet"

# User messages
GU_ERROR_FETCH_FAIL="Unable to fetch the remote repository."
GU_ERROR_UPDATE_FAIL="Unable to update the local repository."
GU_ERROR_NO_GIT="This directory has not been initialized with Git."
GU_INFO_REPOS_EQUAL="The local repository is current. No update is needed."
GU_SUCCESS_REPORT="Update complete."

cd /root/Page-Source/

if [ -d ".git" ]; then
  # update remote tracking branch
  git remote update >&-
  if (( $? )); then
      echo $GU_ERROR_FETCH_FAIL >&2
      exit 1
  else
      LOCAL_SHA=$(git rev-parse --verify HEAD)
      REMOTE_SHA=$(git rev-parse --verify FETCH_HEAD)
      if [ $LOCAL_SHA = $REMOTE_SHA ]; then
          echo $GU_INFO_REPOS_EQUAL
          exit 0
      else
          $GIT_COMMAND
          if (( $? )); then
              echo $GU_ERROR_UPDATE_FAIL >&2
              exit 1
          else
              echo $GU_SUCCESS_REPORT
              echo "Removing Old Page Contents"
              cd /root/page
              git pull
              cd /root/Page-Source 
              Rscript pageMakerLinux.R
              rm -r /root/page/*
              echo "Copying New Page Contents"
	      cp -R static/. /root/page/
              cd /root/page
              echo "Pushing Update"
              git add .
              git commit -m "Automatic Build"
              git push
              echo "Done!"

          fi
      fi
  fi
else
  echo $GU_ERROR_NO_GIT >&2
  exit 1
fi
exit 0
