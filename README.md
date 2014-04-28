
An app that provides information of events related to Chinese Christian community in Sydney.

Event info are retrieved from a server through a RSS feed. The info are organised by helpers for 
SCCCA (http://www.sccca.org.au).

Changes made in v1.1:

- done - Remove the use of storyboard.
    - done - Event list screen
    - done - Event details screen
    - done - Toolbar
    - done - Refresh feature
    - done - Category filter
- done - Optimize codes for iOS7.
- done - Toolbar is hidden in iOS6 - Use Auto Layout.
- done - Fix bug where poster image is not mapped to the correct event.
    - Found that it's because event without image still contains images of other events.
- done - Remove warning message that appears in console during run.
    - Found that this was an Xcode bug. Error is gone after resetting simulator.
- done - Update app icon.
- done - In category screen, pop back to event list screen right after user taps on a category.
- Add Google Analytics tracking.
- Add crash tracking - Crashlytics or others.

Todo:

- The isPublished field is not sourced from RSS guid field, i.e. events cannot be set to hidden by server.
- Update info of existing events on refresh.
- Handle situation when network is unavailable / can't reach server.
- Show location of event using in-app map view.
- Download and save event images.
- Make it a universal app.
- Use ReactiveCocoa.
