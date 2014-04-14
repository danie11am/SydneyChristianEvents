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
 - Layout is set up using Storyboard.
 */
@interface EventListViewController : UIViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    NSXMLParserDelegate
>

@property (strong) NSMutableString *rssTitle;
@property (strong) NSMutableString *rssLink;
@property (strong) NSMutableString *rssDescription;
@property (strong) NSMutableString *rssAuthor;
@property (strong) NSMutableString *rssCategory;
@property (strong) NSMutableString *rssComments;
@property (strong) NSMutableString *rssEnclosure;
@property (strong) NSMutableString *rssEnclosureUrl;
@property (strong) NSMutableString *rssGuid;
@property (strong) NSMutableString *rssPubDate;


@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) NSMutableArray *eventEntries;

@property (strong) NSString *currentElement;
@property (strong, nonatomic) IBOutlet UITableView *tableview;


@property (strong) ActivityIndicatorOverlayVC *activityOverlayVC;



- (IBAction) refreshRSS;


@end
