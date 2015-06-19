[logging]
color = true
console_format = "%(levelname)-8s %(message)s"
debug_format = "%(levelname)-8s %(asctime)s [%(process)d:%(threadName)s] %(name)s\n  %(message)s"
debug_file = mopidy.log
config_file =

[audio]
mixer = software
mixer_volume =
output = autoaudiosink

[proxy]
scheme =
hostname =
port =
username =
password =

[local]
enabled = true
library = json
media_dir = /mnt/music
data_dir = /var/lib/mopidy
scan_timeout = 1000
scan_flush_threshold = 1000
scan_follow_symlinks = false
excluded_file_extensions =
  .directory
  .html
  .jpeg
  .jpg
  .log
  .nfo
  .png
  .txt

