

An app that provides info  that are related to Chinese Christian community in Sydney.

Event info are sourced using RSS entries from a server.

Bug fixing:

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
- Remove warning message that appears in console during run.
- Update app icon.
- Add Google Analytics tracking.

More features:

- The isPublished field is not sourced from the guid field of the RSS field.
- Update info of existing events on refresh.
- Handle situation when network is unavailable / can't reach server.
- Show location of event using in-app map view.
- Download and save event images.
- Make it a universal app.
- Use ReactiveCocoa.
