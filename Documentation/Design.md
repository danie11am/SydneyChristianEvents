

### Overview

Storyboard is not used because it is error-prone and makes collaboration more difficult.

Server database schema is described here:

- https://bitbucket.org/xelat/sccca/wiki/RSS%20and%20Database%20Schema

Info about the Android version of this app and the project in general can be found here:

- https://bitbucket.org/xelat/sccca/wiki/Home


### Deployment

Before uploading to iTune app store, make sure that:

- API key and debug variable in AnalyticsHelpers.m is set properly for production.

After submitting to app store, make sure that:

- API key and debug variable in AnalyticsHelpers.m is set properly for development.



### RSS Feeds

Current production RSS feeds are retrieved from:

- http://sccca.org.au/events130315e/feed

This should be changed to another service at

- http://sccca.org.au/rest/events130724.xml

...which contains more info about host and language of the event.



### Downloading of Event info

A HTTP call to retrieve event info through RSS feed is made in the initial app run. On subsequent runs, there will 
no longer be auto download, but user can tap on refresh button in toolbar to retrieve the latest event info.

Downloading and parsing of the RSS feed (an XML file) are done using an iOS built-in class called NSXMLParser.
Content of XML file are saved into memory during parsing of the XML file, which happens in various call back methods 
of NSXMLParserDelegate.

- didEndElement - closing tag of an element is detected.
- didStartElement - starting tag of an element is detected.
- ... See class file for more parsing events and how they get stored using CoreData.


### Event details

RSS feed at http://sccca.org.au/events130315e/feed includes the following elements:

- item
    - title
        - Maps to EventEntry.title
    - link
        - E.g. "http://sccca.org.au/node/1023"
        - Link to event page of SCCCA website and contains event ID
        - EventEntry.link
        - EventEntry.eventId
    - description
        - EventEntry.eventDescription
    - author (optional)
        - E.g. "7 Crown Street, Harris Park NSW"
        - This actually stores the venue info
        - EventEntry.venue
    - category
        - E.g. "Caring, Relationship"
        - EventEntry.category
    - comments
        - E.g. "1399541400 to 1399550400"
        - Timestamp of start and end time of the event.
        - EventEntry.fromTime
        - EventEntry.toTime
    - guid
        - E.g. "Yes"
        - Flag to indicate if event should be published.
        - This is used to hide an event that has previously been published.
        - EventEntry.isPublished
    - enclosure (optional)
        - E.g. `<enclosure url="http://sccca.org.au/sites/default/files/mffc2014.jpg" length="157046" type="image/jpeg" />`
        - The URL attribute of this element contains a link to event image.
        - EventEntry.poster
    - pubDate
        - E.g. "1391746575"
        - EventEntry.eventPublishedDate


The EventEntry object includes the following properties:

- eventId
- title
- link
- eventDescription
- venue
- category
- poster
- isPublished
- eventPublishedDate
- fromTime
- toTime


### Persistence Storage

Two types of persistence storage are used in this app:

- User Defaults
    - To store the flag that indicate whether or not the app has run at least once.
    - To store the Category filter criteria
- Core Data
    - To store event details.
    
    
    
### Tracking events

This app uses Flurry Analytics to track user usage behavior. See AnalyticsHelpers.m for tracked event details.


