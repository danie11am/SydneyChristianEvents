

### Overview

Storyboard is not used because it is error-prone and makes collaboration more difficult.

Server database schema is described here:

- https://bitbucket.org/xelat/sccca/wiki/RSS%20and%20Database%20Schema

Info about the Android version of this app and the project in general can be found here:

- https://bitbucket.org/xelat/sccca/wiki/Home



### Downloading of Event info

A HTTP call to retrieve event info through RSS feed is made in the initial app run.

On subsequent runs, there will no longer be auto-refresh, but user can tap on refresh button in toolbar to retrieve
the latest event info.



### Persistence Storage

Two types of persistence storage is used in this app: 

- User Defaults
    - To store the flag that indicate whether or not the app has run at least once.
    - To store the Category filter criteria
- Core Data
    - To store event details.
