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
