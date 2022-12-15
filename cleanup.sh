#!/bin/Bash
#This script finds files by name and then compresses them and renames them. Once compressed files are deleted. Files older than 31 days are deleted from the backup.

EncKey=$(lpass show -q --password DefaultEncryption)
myMount=`df -h | grep Ext | awk '{ print $9 }' | cut -d "/" -f 3`
compressedFile="/Volumes/ExtDSK4TB/$(date -v-1d '+%Y_%m_%d').tar.gz"
if [ ${myMount} = "ExtDSK4TB" ] && [ ! -f $compressedFile ];
	then
		tar czvf - /Volumes/Public/SystemLogs_$(date -v-1d '+%Y_%m_%d')* | openssl enc -e -aes256 -out /Volumes/ExtDSK4TB/$(date -v-1d '+%Y_%m_%d').tar.gz -pass pass:$EncKey >/tmp/stdout.log 2>/tmp/stderr.log
		rm -fr /Volumes/Public/SystemLogs_$(date -v-1d '+%Y_%m_%d')*
		find /Volumes/ExtDSK4TB/ -mtime +31 | grep .gz | xargs rm -f
	else
		echo 'Destination file already exists or drive is not mounted. Exiting'
fi
