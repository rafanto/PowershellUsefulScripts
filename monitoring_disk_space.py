```
# Python script to monitor disk space and send an alert if it's low
import psutil
def check_disk_space(minimum_threshold_gb):
disk = psutil.disk_usage('/')
free_space_gb = disk.free / (230) # Convert bytes to GB
if free_space_gb < minimum_threshold_gb:
# Your code here to send an alert (email, notification, etc.)
pass
```
