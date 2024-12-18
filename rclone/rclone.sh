#!/bin/bash
# rclone sync from Google Photos to local storage

/usr/bin/rclone sync 'google-photos':media/by-day '/mnt/Storage/Cloud Storage/Google Photos/' --verbose -P
