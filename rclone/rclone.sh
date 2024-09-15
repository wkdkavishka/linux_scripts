#!/usr/bin/bash
# ---------
# rclone sync 'One Drive Master': '/mnt/storage-500/Cloud Storage/One Drive'
#
# rclone sync 'Google Drive Master': '/mnt/storage-500/Cloud Storage/Google Drive Master'
#
# rclone sync 'Google Drive': '/mnt/storage-500/Cloud Storage/Google Drive'

rclone sync 'google-photos':media/by-day '/mnt/Storage/Cloud Storage/Google Photos/'  --verbose -P
