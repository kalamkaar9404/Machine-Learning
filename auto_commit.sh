#!/bin/bash

# Ensure the script stops on error
set -e

# Loop through all files in the directory
for file in $(find . -type f -name "*.ipynb"); do
    # Get the creation date in UNIX timestamp format
    creation_date=$(stat --format='%W' "$file")

    # Convert timestamp to a readable date format
    commit_date=$(date -d @$creation_date --iso-8601=seconds)

    # If the creation date is not available (some systems use %W = 0 if unknown), use last modified date
    if [ "$creation_date" -eq 0 ]; then
        commit_date=$(date -r "$file" --iso-8601=seconds)
    fi

    # Add the file to Git
    git add "$file"

    # Commit the file with the original creation date as the commit date
    GIT_COMMITTER_DATE="$commit_date" git commit --date="$commit_date" -m "Added $file with original timestamp"
done

# Push to Gi
