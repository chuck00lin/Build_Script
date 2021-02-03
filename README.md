# Build_Script
For raspberry pi environment

---
## Realsense SDK Build

### Dependencies:
- libusb-1.0-0-dev
- pkg-config
- libglfw3-dev
- libssl-dev

-python3,python3-dev

### With cmake flag:
- DBUILD_EXAMPELS=true
- DBUILD_SHARED_LIBS=false (static library)
#-DBUILD_PYTHON_BINDINGS=bool:true (temporary removed)

### After build:
cp udev rules to /etc/udev/rules.d/
``` 
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevam trigger
```
---
