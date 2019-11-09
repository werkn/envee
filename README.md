# ENVEE

**ENVEE** (Short for **ENV**ironm**E**nt s**E**tup) is a tool for automating your desktop layout using JSON.  It uses a combination of Powershell and AHK (AutoHotKey), although it currently only works for Windows porting it to AppleScript would be fairly simple.  

This is a tool I developed for myself without the intention of releasing to a larger audience but it works for the most part and a few people have expressed interest.

ENVEE supports window layouts on multiple monitors across multiple virtual desktops.

Due to the fact that (as of Windows 10 - 1903) there is no direct API access for the virtual desktop implementation we switch between desktops by sending the `CTRL+WIN+{LEFT | RIGHT}`, and this is done via `virtual-desktop-keys.exe`.  

*Note:  If and when Windows releases a stable API I'll more then likely port to a C#/Powershell implementation.*

## `Setup-Environment.ps1`


Ensure you are on the first virtual desktop and that the master/main display if on a dual monitor setup is the leftmost display.

Usage:

```powershell
#launch setup script, note web is the environment name from config.json
powershell.exe Setup-Environment.ps1 -environmentToStart web
```

## `virtual-desktop-keys.ahk / virtual-desktop-keys.exe`
Due to the fact that (as of Windows 10 - 1903) there is no direct API access for the virtual desktop implementation we switch between desktops by sending the `CTRL+WIN+{LEFT | RIGHT}`, and this is done via `virtual-desktop-keys.exe`.  

`virtual-desktop-keys.exe` is simply a compiled AHK script as this was the fastest and hassle free option to enable sending virtual desktop and windows position keyboard shortcuts.

Supported arguments to `virtual-desktop-keys.exe`:

```powershell
virtual-desktop-keys.exe 
    --settop[left | right] #send command to position active window @ topleft of screen 
    --setbottom[left | right] #send command to position active window @ bottom left of screen
    --set[left | right] #send command to snap window left or right
    --send[up | down | left | right] #send snap up, down, left or right 
    --right #move to next virtual desktop
    --left #move to last virtual desktop
    --new #create a new virtual desktop
    --kill #destroy current virtual desktop
```

## `config.json`

Below is an example config.json with all configurable fields.  A few notes on producing this config.

The JSON file is segmented into an array of `environments`, in the example below we have `web` and `anki` as the two environments.  Within each environment we have three virtual desktops to be setup indicated by `desktop0, desktop1, desktop2`.  The apps to be launched on the associated desktops are stored within the `app` object of each `desktopN` object.  Within the apps object the following fields can be added / need to be configured as:


| Field        | Type           | Comment  |
| ------------- |:-------------: | :-----|
| `processName`      | `String` | The processName must match exactly the name of your application process (with a GUI).  The easiest way to determine this is to launch your application and verify app names listed in `Get-Process` using Powershell  |
| `startupDelay`      | `Integer` |   Startup delay in seconds to wait before sending any movement / positioning commands to your app.  If your app takes a long to startup modify this value accordingly |
| `path` |  `String`  |    The full path to your executable.  If its added to PATH just use the name of your application, ie: chrome |
| `args` |  `String[]` | Include as an array any command line arguments needed by your app |
| `maximized` |  `Boolean` | Set to true to maximize your app window, this field is optional, omit to do nothing |
| `size.mode` | `String`      | Mode used to size your app window, can be set to `pixel` or `percent` |
| `size.width` | `Integer` or `Float` | If mode is set to `pixel` use integer value if it is `percent` use a float between 0 and 1. |
| `size.height` | `Integer` or `Float` | If mode is set to `pixel` use integer value if it is `percent` use a float between 0 and 1. |
| `topLeft.mode` | `String` | Mode used to position your app window, can be set to `pixel` or `percent` | 
| `topLeft.x` | `Integer` or `Float` | If mode is set to `pixel` use integer value if it is `percent` use a float between 0 and 1. |
| `topLeft.y` | `Integer` or `Float` | If mode is set to `pixel` use integer value if it is `percent` use a float between 0 and 1. |

### Example `config.json`
```json
{
  "environments": [
    {
      "name": "web",
      "environment": {
        "desktop0": {
          "apps": {
            "ubuntu": {
              "processName": "ubuntu",
              "startupDelay": 2,
              "path": "ubuntu",
              "args": [],
              "size": {
                "mode": "percent",
                "width": 0.5,
                "height": 1.0
              },
              "topLeft": {
                "mode": "percent",
                "x": 0,
                "y": 0
              }
            },
            "cmd": {
              "processName": "cmd",
              "startupDelay": 2,
              "path": "cmd",
              "args": [
                "\/K",
                "\"cd C:\\Users\\werkn\\Documents\\GitHub\\\""
              ],
              "size": {
                "mode": "percent",
                "width": 0.5,
                "height": 0.5
              },
              "topLeft": {
                "mode": "percent",
                "x": 0.5,
                "y": 0.5
              }
            }
          }
        },
        "desktop1": {
          "apps": {
            "code": {
              "processName": "Code",
              "startupDelay": 4,
              "path": "code",
              "args": [],
              "size": {
                "mode": "percent",
                "width": 1.0,
                "height": 1.0
              },
              "topLeft": {
                "mode": "percent",
                "x": 0,
                "y": 0
              }
            },
            "chrome": {
              "processName": "chrome",
              "startupDelay": 2,
              "path": "chrome",
              "args": [
                "https://youtube.com",
                "http://localhost:3000"
              ],
              "size": {
                "mode": "px",
                "width": 1080,
                "height": 1920
              },
              "topLeft": {
                "mode": "percent",
                "x": 1.0,
                "y": 0
              }
            }
          }
        },
        "desktop2": {
          "apps": {
            "firefox": {
              "processName": "firefox",
              "startupDelay": 2,
              "path": "firefox",
              "args": [
                "https://www.youtube.com/watch?v=WI4-HUn8dFc"
              ],
              "maximized": true,
              "size": {
                "mode": "percent",
                "width": 1.0,
                "height": 1.0
              },
              "topLeft": {
                "x": 0,
                "y": 0
              }
            },
            "alarms": {
              "processName": "Time",
              "startupDelay": 2,
              "path": "explorer.exe",
              "args": [
                "shell:Appsfolder\\Microsoft.WindowsAlarms_8wekyb3d8bbwe!App"
              ],
              "size": {
                "mode": "percent",
                "width": 0.5,
                "height": 1.0
              },
              "topLeft": {
                "x": 0,
                "y": 0
              }
            }
          }
        }
      }
    },
    {
      "name": "anki",
      "environment": {
        "desktop0": {
          "apps": {}
        },
        "desktop1": {
          "apps": {
            "firefox": {
              "processName": "firefox",
              "startupDelay": 2,
              "path": "firefox",
              "args": [],
              "size": {
                "mode": "percent",
                "width": 0.5,
                "height": 1.0
              },
              "topLeft": {
                "x": 0,
                "y": 0
              }
            },
            "anki": {
              "processName": "anki",
              "startupDelay": 10,
              "path": "C:\\Program Files\\Anki\\anki.exe",
              "args": [],
              "size": {
                "mode": "percent",
                "width": 0.5,
                "height": 0.5
              },
              "topLeft": {
                "mode": "percent",
                "x": 0.5,
                "y": 0
              }
            }
          }
        },
        "desktop2": {
          "apps": {}
        }
      }
    }
  ]
}

```

