//
//  EventListViewController.h
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 6/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventEntry, ActivityIndicatorOverlayVC;

/**
 Main screen of the app.
 
 - Show the events in a list format using table view.
 - Send request to web server to receive event details in RSS format.
 - Parse received RSS entries and save to persistent storage using Core Data.
 */
@interface EventListViewController : UIViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    NSXMLParserDelegate
>

@end
