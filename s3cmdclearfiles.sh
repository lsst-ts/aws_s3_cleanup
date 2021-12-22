#!/bin/bash

# Usage: ./s3cmdclearfiles.sh "bucketname" "30d"
 
aws s3 ls s3://$1 | grep " DIR " -v | while read -r line;
  do
    createDate=`echo $line|awk {'print $1" "$2'}`
    #createDate=`date -f "%Y-%m-%d %H:%M:%S" "$createDate" +%s`
    createDate=`date -d "$createDate" +%s`
    if [[ "$1" == *releases* ]]; then 
        olderThan=`date -d "-1 year" +%s`
    else
        olderThan=`date -d "-1 month" +%s`
    fi
    if [[ $createDate -lt $olderThan ]]
      then
        fileName=`echo $line|awk {'print $4'}`
        if [[ $fileName != "" ]]
          then
            printf 'Deleting "%s"\n' s3://$1$fileName
            aws s3 rm s3://$1"$fileName"
        fi
    fi
  done;
