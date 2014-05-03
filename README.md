
iOS app that provides information of events related to Chinese Christian community in Sydney, available in [App Store](https://itunes.apple.com/us/app/catch-chinese-christian-events/id649820279?mt=8). This app can be run on devices with iOS 6.0 and above.

Event info are retrieved from a server through a RSS feed. These info are organised by helpers for SCCCA (http://www.sccca.org.au). See Design.md in Documentation folder for more info.

This app is not for profit and has been open-sourced as a contribution to the community. There are still lots to be done! If you are interested to help and contribute, please contact [myself](https://github.com/danie11am).


### Todos 

These should be moved to issues list in GitHub later.

- The isPublished field is not sourced from RSS guid field, i.e. events cannot be set to hidden by server.
- Use the improved RSS feed (see Design.md for more info).
- Update info of existing events on refresh.
- Handle situation when network is unavailable / can't reach server.
- Show location of event using in-app map view.
- Download and save event images.
- Add pull-to-refresh.
- Add first-use guide.
- Make it a universal app.


### Change Logs

***Changes made in v1.1***

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
- done - Add Flurry Analytics tracking.
- done - Add crash tracking - Flurry Analytics includes it.
- done - Define all the Flurry event strings in one place.
- done - Make sure the app supports only iOS6 and above.
- done - Hide events from past dates.

"What's New" message displayed to public in v1.1:

    Fixed major issues in app! For best results please uninstall and re-install the app.
    - Supports iOS7!
    - Used new logo!
    - Fixed app crashing that happens in older devices. App now supports only iOS6 and above.
    - Past events are no longer shown.
    - Fixed mismatching event photo.

