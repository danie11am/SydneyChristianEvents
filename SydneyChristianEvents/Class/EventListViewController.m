//
//  EventListViewController.m
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 6/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import "EventListViewController.h"
#import "EventDetailsVC.h"
#import "EventEntry.h"
#import "EventEntryCell.h"
#import "AppUtil.h"
#import "ActivityIndicatorOverlayVC.h"
#import "CategoryVC.h"

@interface EventListViewController ()

@property (strong) NSMutableString *rssTitle;
@property (strong) NSMutableString *rssLink;
@property (strong) NSMutableString *rssDescription;
@property (strong) NSMutableString *rssAuthor;
@property (strong) NSMutableString *rssCategory;
@property (strong) NSMutableString *rssComments;
@property (strong) NSMutableString *rssEnclosureUrl;
@property (strong) NSMutableString *rssGuid;
@property (strong) NSMutableString *rssPubDate;


@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) NSMutableArray *eventEntries;
@property (strong) NSString *currentElement;

@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) UIToolbar *toolbar;

@property (strong) ActivityIndicatorOverlayVC *activityOverlayVC;



@end


@implementation EventListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"澳洲雪梨 基督教 公開聚會";

    // Add table view.
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: self.tableview];


    // Add toolbar.
    self.toolbar = [[UIToolbar alloc] initWithFrame: CGRectZero];
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(refreshRSS)
                                    ];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil
                                      ];
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                target:self
                                                                                action:@selector(pushCategoryVC)
                                   ];
    [toolbarItems addObject: refreshItem];
    [toolbarItems addObject: flexibleSpace];
    [toolbarItems addObject: filterItem];
    [self.toolbar setItems: toolbarItems];
    [self.view addSubview:self.toolbar];
    
    [self addConstraints];


    // Debugging.
    /*
    self.view.backgroundColor = [UIColor blueColor];
    self.tableview.backgroundColor = [UIColor yellowColor];
     */


    // Check if user running for the first time and retrieve event info if so.
    //
    // Name of the flag is misleading - if "isFirstRun" is YES, it does not mean this is the first run.
    // Rather, "isFirstRun" is set during first run, therefore being YES means that it's NOT the first run.
    // ...Sorry!
    //
    int isFirstRun = [[NSUserDefaults standardUserDefaults] integerForKey: @"isFirstRun"];
    
    if (isFirstRun == 0)
    {
        [[NSUserDefaults standardUserDefaults] setInteger: 1 forKey: @"isFirstRun"];

        // Make the change effective immediately.
        [[NSUserDefaults standardUserDefaults] synchronize];

        [self refreshRSS];
    }
    
    
}



- (void)viewWillAppear:(BOOL)animated
{
    // Debugging.
    //NSLog(@"NewsViewController.m: viewWillAppear(): called");
    
    [super viewWillAppear:animated];

    // Read from CoreData to read the event entries.
    [self fetchDatabase];
    [self.tableview reloadData];

    // "Deselect" the row, otherwise the cell will remain highlighted.
    [self.tableview deselectRowAtIndexPath: [self.tableview indexPathForSelectedRow]
                                  animated:YES
     ];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Custom methods



/** Set auto-layout constraints for UI components. */
- (void) addConstraints
{
    
    NSArray *allConstraints = @[
                                // Set table view
                                // ...to fit all edges of self.view except bottom, which sticks with toolbar.
                                [NSLayoutConstraint constraintWithItem: self.tableview
                                                             attribute: NSLayoutAttributeTop
                                                             relatedBy: NSLayoutRelationEqual
                                                                toItem: self.view
                                                             attribute: NSLayoutAttributeTop
                                                            multiplier: 1.0
                                                              constant: 0
                                 ],
                                [NSLayoutConstraint constraintWithItem: self.tableview
                                                             attribute: NSLayoutAttributeRight
                                                             relatedBy: NSLayoutRelationEqual
                                                                toItem: self.view
                                                             attribute: NSLayoutAttributeRight
                                                            multiplier: 1.0
                                                              constant: 0
                                 ],
                                [NSLayoutConstraint constraintWithItem: self.tableview
                                                             attribute: NSLayoutAttributeBottom
                                                             relatedBy: NSLayoutRelationEqual
                                                                toItem: self.toolbar
                                                             attribute: NSLayoutAttributeTop
                                                            multiplier: 1.0
                                                              constant: 0
                                 ],
                                [NSLayoutConstraint constraintWithItem: self.tableview
                                                             attribute: NSLayoutAttributeLeft
                                                             relatedBy: NSLayoutRelationEqual
                                                                toItem: self.view
                                                             attribute: NSLayoutAttributeLeft
                                                            multiplier: 1.0
                                                              constant: 0
                                 ],
                                // Set toolbar
                                // ...to be at the bottom of the screen.
                                [NSLayoutConstraint constraintWithItem: self.toolbar
                                                             attribute: NSLayoutAttributeHeight
                                                             relatedBy: NSLayoutRelationEqual
                                                                toItem: nil
                                                             attribute: NSLayoutAttributeNotAnAttribute
                                                            multiplier: 1.0
                                                              constant: 44
                                 ],
                                [NSLayoutConstraint constraintWithItem: self.toolbar
                                                             attribute: NSLayoutAttributeLeft
                                                             relatedBy: NSLayoutRelationEqual
                                                                toItem: self.view
                                                             attribute: NSLayoutAttributeLeft
                                                            multiplier: 1.0
                                                              constant: 0
                                 ],
                                [NSLayoutConstraint constraintWithItem: self.toolbar
                                                             attribute: NSLayoutAttributeRight
                                                             relatedBy: NSLayoutRelationEqual
                                                                toItem: self.view
                                                             attribute: NSLayoutAttributeRight
                                                            multiplier: 1.0
                                                              constant: 0
                                 ],
                                [NSLayoutConstraint constraintWithItem: self.toolbar
                                                             attribute: NSLayoutAttributeBottom
                                                             relatedBy: NSLayoutRelationEqual
                                                                toItem: self.view
                                                             attribute: NSLayoutAttributeBottom
                                                            multiplier: 1.0
                                                              constant: 0
                                 ],
                                ];
    
    [self.view addConstraints: allConstraints];
    
}



- (void) parseXMLFileAtURL: (NSString *) inputURL
{

    NSLog(@"ViewController.m: parseXMLFileAtURL(): Started.");
    


//    NSString *myRequestString =
//    [NSString stringWithFormat:@"http://abc.com/def/webservices/aa.php?family_id=%d",self.passFamilyId];
    
    //NSLog(@"Requested Service = %@",myRequestString);

//    NSMutableURLRequest *request =
//    [[NSMutableURLRequest alloc] initWithURL:
//     [NSURL URLWithString: inputURL]
//     ];
//
//    [request setHTTPMethod: @"POST" ];
//
//    NSData *downloadedData =
//    [ NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    
    
    // Convert URL from NSString* to NSURL.
    NSURL *nsURL = [NSURL URLWithString:inputURL];
    //NSURL *nsURL = [NSURL fileURLWithPath:inputURL];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL: nsURL];
    [xmlParser setDelegate: self];


    // Turn off the unnecessary features.
    [xmlParser setShouldProcessNamespaces: NO];
    [xmlParser setShouldReportNamespacePrefixes: NO];
    [xmlParser setShouldResolveExternalEntities: NO];

    // Get the XML file and parse the content.
    [xmlParser parse];
    
}



/** 
 Show the list of available event categories.
 Called when user tap on the filter icon. 
 */
- (void) pushCategoryVC
{
    [AnalyticsHelper logEvent:AnalyticsHelperEventTypeChangeCategoryOpened];
    CategoryVC *categoryVC = [[CategoryVC alloc] initWithStyle: UITableViewStyleGrouped];
    [self.navigationController pushViewController:categoryVC animated:YES];
}



/** 
 Retrieve event info from RSS feed. 
 Called when user taps on refresh icon, or automatically during initial run.
 */
- (IBAction) refreshRSS
{
    NSLog(@"ViewController.m: refreshRSS(): Started.");
    [AnalyticsHelper logEvent:AnalyticsHelperEventTypeRefreshButtonTapped];


    // Show the Activity Overlay ("Loading").
    //
    // For some reason, it seems that the loading sign will *randomly*
    // not show if the method is called directly.
    //
    // This could be due to some racing conditions in the UI.
    //
    //[self showLoadingSign];
    //
    [self performSelector:@selector(showLoadingSign)
               withObject: nil
               afterDelay:0.1
     ];
    
    NSString *rssFeedURL = @"http://sccca.org.au/events130315e/feed";

    // Get the RSS feed xml file and parse it.
    //
    // This must be called through the performSelector instead of calling directly, like the following,
    //   [self parseXMLFileAtURL: rssFeedURL];
    //
    // Calling directly would cause the Activity Indicator Overlay not able to be displayed, because it takes some
    // time before the next re-draw cycle.
    //
    [self performSelector:@selector(parseXMLFileAtURL:)
               withObject:rssFeedURL
               afterDelay:0.5
     ];
}



- (void) fetchDatabase
{
    
    // Fetch existing entries from database.
    //
    // Create a fetch request; find the EventEntry entity and assign it to the request; add a sort descriptor;
    // then execute the fetch.
    //
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"EventEntry"
                inManagedObjectContext: self.managedObjectContext
     ];

    [request setEntity:entity];


    
    
    //--------------------------------------------------------------------------
    // Set filtering criteria.

    NSPredicate *predicate;

    int categoryId =
    [[NSUserDefaults standardUserDefaults] integerForKey: @"savedCategory"];

    NSString *selectedCategory;

    BOOL useFilter = YES;
    
    switch (categoryId)
    {
        case 0:

            selectedCategory = @"All";

            useFilter = NO;

            break;

        case 1:
            selectedCategory = @"Training";
            break;
            
        case 2:
            selectedCategory = @"Youth";
            break;
            
        case 3:
            selectedCategory = @"Mission";
            break;
            
        case 4:
            selectedCategory = @"Revival";
            break;
            
        case 5:
            selectedCategory = @"Family";
            break;
            
        case 6:
            selectedCategory = @"Relationship";
            break;
            
        default:

            useFilter = NO;

    }
    
    if (useFilter)
    {
        
        predicate = [NSPredicate predicateWithFormat:
                     @"category contains[c] %@",
                     selectedCategory
                     ];

        [request setPredicate: predicate];
    }
    
    

    //--------------------------------------------------------------------------
    // Order the events by creation date, most recent first.
    //
    NSSortDescriptor *sortDescriptor =
    [[NSSortDescriptor alloc] initWithKey: @"fromTime"
                                ascending: YES
     ];
    
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sortDescriptor, nil];

    [request setSortDescriptors:sortDescriptors];


    NSError *error = nil;


    // Execute the fetch -- create a mutable copy of the result.
    //
    // Seems that both ways are the same.
    //
    //    NSMutableArray *mutableFetchResults =
    //    [[managedObjectContext executeFetchRequest:request
    //                                         error:&error] mutableCopy];
    //
    NSArray *mutableFetchResults =
    [self.managedObjectContext executeFetchRequest:request
                                        error:&error
     ];

    if (mutableFetchResults == nil) {

        // Handle the error.
        NSLog(@"Error occured in ViewController.m: fetchDatabase():");

        if (error == nil) {

            NSLog(@"NSError is nil.");
            
        } else {
            
            NSLog(@"NSError description: %@", [error localizedDescription]);
        }
    }
    
    
    // Debugging.
    /*
     NSLog(@"ViewController.m: fetchDatabase(): result count: %i",
           [mutableFetchResults count]
           );
     
     for (int i = 0; i < [mutableFetchResults count]; i++) {
     
         EventEntry *eventEntry = [mutableFetchResults objectAtIndex:i];

         NSLog(@"------------------------- Entry %i:", i);
         NSLog(@"eventId: %@", eventEntry.eventId);
         NSLog(@"title: %@", eventEntry.title);
         NSLog(@"link: %@", eventEntry.link);
         NSLog(@"eventDescription: %@", eventEntry.eventDescription);
         NSLog(@"venue: %@", eventEntry.venue);
         NSLog(@"category: %@", eventEntry.category);
         NSLog(@"poster: %@", eventEntry.poster);
         NSLog(@"isPublished: %@", eventEntry.isPublished);
         NSLog(@"eventPublishedDate: %@", eventEntry.eventPublishedDate);
         NSLog(@"fromTime: %@", eventEntry.fromTime);
         NSLog(@"toTime: %@", eventEntry.toTime);
     
     }
     */


    // Set self's events array to the mutable array, then clean up.
    self.eventEntries =
    [[NSMutableArray alloc] initWithArray: mutableFetchResults];

}



- (BOOL) doesEventAlreadyExist: (int) eventId
{

    //NSLog(@"ViewController.m: doesEventAlreadyExist(): eventId %d", eventId);


    // Fetch existing entries from database.
    //
    // Create a fetch request; find the EventEntry entity and assign it to the
    // request; add a sort descriptor; then execute the fetch.
    //
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity =
    [NSEntityDescription entityForName:@"EventEntry"
                inManagedObjectContext: self.managedObjectContext
     ];
    
    [request setEntity:entity];
    
    
    
    
    //--------------------------------------------------------------------------
    // Set filtering criteria.
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat: @"eventId = %d", eventId];
    
    [request setPredicate: predicate];



    //--------------------------------------------------------------------------
    // Execute the fetch.
    
    NSError *error = nil;
    
    
    // Execute the fetch -- create a mutable copy of the result.
    //
    // Seems that both ways are the same.
    //
    //    NSMutableArray *mutableFetchResults =
    //    [[managedObjectContext executeFetchRequest:request
    //                                         error:&error] mutableCopy];
    //
    NSArray *mutableFetchResults =
    [self.managedObjectContext executeFetchRequest:request
                                             error:&error
     ];
    
    if (mutableFetchResults == nil) {

        // Handle the error.
        NSLog(@"Error occured in ViewController.m: doesEventAlreadyExist():");
        
        if (error == nil) {
            
            NSLog(@"NSError is nil.");
            
        } else {
            
            NSLog(@"NSError description: %@", [error localizedDescription]);
        }
    }
    
    
    // Debugging.
    /*
     NSLog(@"ViewController.m: fetchDatabase(): result count: %i",
     [mutableFetchResults count]
     );
     
     for (int i = 0; i < [mutableFetchResults count]; i++) {
     
     EventEntry *eventEntry = [mutableFetchResults objectAtIndex:i];
     
     NSLog(@"------------------------- Entry %i:", i);
     NSLog(@"eventId: %@", eventEntry.eventId);
     NSLog(@"title: %@", eventEntry.title);
     NSLog(@"link: %@", eventEntry.link);
     NSLog(@"eventDescription: %@", eventEntry.eventDescription);
     NSLog(@"venue: %@", eventEntry.venue);
     NSLog(@"category: %@", eventEntry.category);
     NSLog(@"poster: %@", eventEntry.poster);
     NSLog(@"isPublished: %@", eventEntry.isPublished);
     NSLog(@"eventPublishedDate: %@", eventEntry.eventPublishedDate);
     NSLog(@"fromTime: %@", eventEntry.fromTime);
     NSLog(@"toTime: %@", eventEntry.toTime);
     
     }
     */
    
    BOOL eventAlreadyExist = NO;
    
    if ([mutableFetchResults count] > 0)
    {
        //NSLog(@"ViewController.m: doesEventAlreadyExist(): event already exists.");

        eventAlreadyExist = YES;
    }

    return eventAlreadyExist;

}



#pragma mark - Loading Sign



- (void) hideLoadingSign
{

    [self.activityOverlayVC.view removeFromSuperview];

}



- (void) showLoadingSign
{
    
    
    // Create the Activity Indicator if it was not already created.
    if (self.activityOverlayVC == NULL) {
        
        self.activityOverlayVC = [[ActivityIndicatorOverlayVC alloc]
                                  initWithFrame: self.view.superview.bounds
                                  ];
    }
    
    
    // Add the view on top of current view.
    //
    // This is another way of doing it.
    //[self.navigationController.view addSubview: self.activityOverlayVC.view];
    //
    [self.view.superview insertSubview: self.activityOverlayVC.view
                          aboveSubview: self.view
     ];

}



#pragma mark - Core Data stack



/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the
 persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{
	
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator =
    [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }

    return _managedObjectContext;
}



/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models
 found in the application bundle.
 */
- (NSManagedObjectModel *) managedObjectModel
{

    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    return _managedObjectModel;

}



/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's
 store added to it.
 */
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator
{


    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }

    NSString *appDocDirectory =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES)
    [0];


    NSURL *storeUrl =
    [NSURL fileURLWithPath:
     [appDocDirectory //@""//[self applicationDocumentsDirectory]
      stringByAppendingPathComponent: @"sydneychristianevent.sqlite"
      ]
     ];
	
	NSError *error;

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:
                                  [self managedObjectModel]];


    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeUrl
                                                        options:nil
                                                          error:&error])
    {
        // Handle the error.
        NSLog(@"ViewController.m: persistentStoreCoordinator(): Error! ");

    }
    
    return _persistentStoreCoordinator;
}



#pragma mark - UITableViewDataSource Protocol



- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.eventEntries count];
}



- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{

    //NSLog(@"ViewController.m: cellForRowAtIndexPath(): started.");
    
    NSString *cellIdentifier = @"EventCell";


    EventEntryCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];


    if (cell == nil) {

        cell = [[EventEntryCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: cellIdentifier
                ];

    }

    EventEntry *eventEntry = [self.eventEntries objectAtIndex: indexPath.row];

    //NSLog(@"eventEntry details: [%@]", eventEntry.description);
    
    NSString *dateStr =
    [AppUtil convertToStringStartDate: eventEntry.fromTime
                               toDate: eventEntry.toTime
     ];

    cell.eventTitleLabel.text = eventEntry.title;
    cell.eventDateLabel.text = dateStr;

    return cell;
}



#pragma mark - UITableViewDelegate Protocol



- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"ViewController.m: didSelectRowAtIndexPath: called.");
    
    // Get the Event and pass it to the EventDetailsVC.
    EventDetailsVC *detailsVC = [[EventDetailsVC alloc] init];
    EventEntry *event = [self.eventEntries objectAtIndex: indexPath.row];
    detailsVC.eventEntry = event;

    NSDictionary *eventParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 event.eventId, @"event_id",
                                 event.title, @"event_title",
                                 event.category, @"event_category",
                                 nil
                                 ];
    [AnalyticsHelper logEvent:AnalyticsHelperEventTypeEventDetailsOpened withParameters:eventParams];


    [self.navigationController pushViewController:detailsVC animated:YES];
    
}



#pragma mark - NSXMLParserDelegate functions



- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    // Debugging.
    NSLog(@"ViewController.m: parserDidStartDocument");
}



- (void)        parser:(NSXMLParser *)parser
    parseErrorOccurred:(NSError *)parseError
{

    // 2013-05-12 00:15
    //
    // There was an odd issue where, when the internet connection of the device
    // is done via Wireless LAN, an error will be thrown at RANDOM times:
    //
    // NSXMLParserErrorDomain error 5
    //
    // This error does not seem to manifest when internet is done via 3G.
    //
    // This could be caused by some odd delay/caching mechanism by the ISP.
    //
    // When the error occurs, the line# and column# are both 1 in the log
    // statement below.
    //
    // Tried to debug by using Charles Web Proxy. When proxy is used,
    // this error cannot be reproduced.
    //
    // Then tried again without Charlex Web Proxy, this error still cannot
    // be reproduced.


    // Compose an error message based on the the error code.
    NSString *errorString = [NSString
                             stringWithFormat:@"Encountered parse error %d, %@, line no %d, column no %d",
                             [parseError code],
                             [parseError description],
                             [parser lineNumber],
                             [parser columnNumber]
                             ];

    // Log the error.
    NSLog(@"Error parsing XML: %@", errorString);

}



- (void)        parser:(NSXMLParser *)parser
    validationErrorOccurred:(NSError *)validationError
{
    
    // Compose an error message based on the the error code.
    NSString *errorString = [NSString
                             stringWithFormat:@"Encountered validation error %d, %@",
                             [validationError code],
                             [validationError description]
                             ];
    
    // Log the error.
    NSLog(@"Error validating XML: %@", errorString);
}



- (void)    parser:(NSXMLParser *)parser
   didStartElement:(NSString *) elementName
      namespaceURI:(NSString *) namespaceURI
     qualifiedName:(NSString *) qualifiedName
        attributes:(NSDictionary *)attributeDict
{
    
    
    // Debugging.
    //NSLog(@"ViewController.m: didStartElement(): elementName: %@", elementName);


    // Remember which element is being processed.
    //
    self.currentElement = [elementName copy];


    if ([elementName isEqualToString: @"item"])
    {
        
        // Clear all the fields belonging to an RSS item, so that new data
        // can be saved to these fields.


        // Debugging.
        //NSLog(@"didStartElement(): ---------------------------------------------------");
        //NSLog(@"ViewController.m: didStartElement(): new item element - empty var holders.");


        self.rssTitle = [[NSMutableString alloc] init];
        self.rssLink = [[NSMutableString alloc] init];
        self.rssDescription = [[NSMutableString alloc] init];
        self.rssAuthor = [[NSMutableString alloc] init];
        self.rssCategory = [[NSMutableString alloc] init];
        self.rssComments = [[NSMutableString alloc] init];
        self.rssEnclosureUrl = [[NSMutableString alloc] init];
        self.rssGuid = [[NSMutableString alloc] init];
        self.rssPubDate = [[NSMutableString alloc] init];

    } else if ([elementName isEqualToString: @"enclosure"])
    {
        
        NSString *urlValue=[attributeDict valueForKey:@"url"];

        //NSLog(@"didStartElement(): enclosure: url: %@", urlValue);
        
        self.rssEnclosureUrl =
        [NSMutableString stringWithString: urlValue];

    }

}



- (void)    parser:(NSXMLParser *)parser
     didEndElement:(NSString *)elementName
      namespaceURI:(NSString *)namespaceURI
     qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString: @"item"]) {
        
        // Debugging.
        //
        /*
        NSLog(@"NewsViewController.m: didEndElement(): 'item' ended.");

        NSLog(@"  - title: %@", self.rssTitle);
        NSLog(@"  - link: %@", self.rssLink);
        NSLog(@"  - description: %@", self.rssDescription);
        NSLog(@"  - author: %@", self.rssAuthor);
        NSLog(@"  - category: %@", self.rssCategory);
        NSLog(@"  - comments: %@", self.rssComments);
        NSLog(@"  - enclosureUrl: %@", self.rssEnclosureUrl);
        NSLog(@"  - guid: %@", self.rssGuid);
        NSLog(@"  - pubDate: %@", self.rssPubDate);
         */


        //----------------------------------------------------------------------
        // Prepare various variables that will be used to insert/update
        // database entry.

        // Get blogId from URL.
        //
        int blogId =
        [AppUtil getBlogIdFromLink: self.rssLink];


        // Prepare fromTime and toTime.
        //
        NSMutableArray *fromTimeAndToTime =
        [AppUtil convertCommentsFieldToDates: self.rssComments];
        
        NSDate *fromTime = nil;
        NSDate *toTime = nil;
        
        if ([fromTimeAndToTime count] > 0 )
        {
            fromTime = [fromTimeAndToTime objectAtIndex: 0];
            
            if ([fromTimeAndToTime count] > 1 )
            {
                toTime = [fromTimeAndToTime objectAtIndex: 1];
            }
        }
    

        // Prepare publish date.
        //
        NSDate *pubDate = nil;
        pubDate = [AppUtil convertTimestampToDate: self.rssPubDate];


//        // Convert string to date object
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        
//        
//        // Set timezone to be GMT, as that's what blogspot returns.
//        //
//        // I.e. Local sydney time is 3/5/2012 3:39pm,
//        // pubDate would be returned as Thu, 03 May 2012 05:39:00 +0000
//        //
//        [dateFormat setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
//        
//        
//        // A sample of the publish date is:
//        //
//        //          1234567890123456789012345
//        // <pubDate>Thu, 26 Apr 2012 09:07:00 +0000</pubDate>
//        //
//        // Only the first 25 characters was taken.
//        //
//        [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
//        
//        NSDate *currentPublishDateInNSDate =
//        [dateFormat dateFromString:currentPublishDate];
//        
//        
//        // A sample of the update date is:
//        //
//        //               1234567890123456789
//        // <atom:updated>2012-04-26T02:44:40.024-07:00</atom:updated>
//        //
//        // Only the first 19 characters was taken.
//        //
//        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//        
//        NSDate *currentUpdateDateInNSDate =
//        [dateFormat dateFromString:currentUpdateDate];
        
        
        //----------------------------------------------------------------------
        // Add this entry to database if it is not already there.

        //
        if (![self doesEventAlreadyExist: blogId])
        {

            // Debugging.
            NSLog(@"ViewController.m: didEndElement(): New entry found.");
            

            EventEntry *eventEntry = (EventEntry *)
            [NSEntityDescription insertNewObjectForEntityForName:@"EventEntry"
                                          inManagedObjectContext: self.managedObjectContext
             ];

            // Trim fields that contain new line characters in the end.
            self.rssTitle = [NSMutableString stringWithString:
                             [self.rssTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                             ];
            self.rssLink = [NSMutableString stringWithString:
                             [self.rssLink stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                             ];
            self.rssAuthor = [NSMutableString stringWithString:
                            [self.rssAuthor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                            ];
            self.rssCategory = [NSMutableString stringWithString:
                            [self.rssCategory stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]
                            ];

            // Set the values of the Blog Entry based on parsed attributes.
            [eventEntry setEventId: [NSNumber numberWithInt: blogId]];
            [eventEntry setTitle: self.rssTitle];
            [eventEntry setLink: self.rssLink];
            [eventEntry setEventDescription: self.rssDescription];
            [eventEntry setVenue: self.rssAuthor];
            [eventEntry setCategory: self.rssCategory];
            [eventEntry setFromTime: fromTime];
            [eventEntry setToTime: toTime];
            [eventEntry setPoster: self.rssEnclosureUrl];
            [eventEntry setIsPublished: [NSNumber numberWithBool: YES]];
            [eventEntry setEventPublishedDate: pubDate];


            
            // Commit the change to database.
            //
            NSError *error;
            
            if (![self.managedObjectContext save:&error]) {
                
                // Handle the error.
                NSLog(@"Error occured in ViewController.m: parser:didEndElement(): New entry found:");
                
                if (error == nil) {
                    
                    NSLog(@"NSError is nil.");
                    
                } else {
                    
                    NSLog(@"NSError description: %@", [error localizedDescription]);
                }
                
            }
            
            // Add the entries to the memory.
            //
            // Another way is to insert in front. Keep for reference.
            //   [_rssEntries insertObject:newEntry atIndex:0];
            //
            // Found that it's better to re-retrieve from database again,
            // because that way the sort order will be enforced.
            // Added fetchDatabase() call from parserDidEndDocument().
            //
            // blogEntries addObject: blogEntry];
            // [blogEntries insertObject: blogEntry  atIndex: 0];
            
            
        } else
        {
            //----------------------------------------------------------------------
            // Entry already exists so update if needed.

            // Debugging.
            NSLog(@"ViewController.m: didEndElement(): Existing entry found.");
            
            
            // Pack new content into one object.
            //
            // There is no init method for NSManagedObject (surprisingly).
            // EventEntry *newEntryContent = [[EventEntry alloc] init];
//            EventEntry *newEntryContent = [EventEntry alloc];


            // Set the values of the Blog Entry based on parsed attributes.
            //
            // There is no setters either for object allocated this way.
//            [newEntryContent setEventId: [NSNumber numberWithInt: blogId]];
//            [newEntryContent setTitle: self.rssTitle];
//            [newEntryContent setLink: self.rssLink];
//            [newEntryContent setEventDescription: self.rssDescription];
//            [newEntryContent setVenue: self.rssAuthor];
//            [newEntryContent setCategory: self.rssCategory];
//            [newEntryContent setFromTime: fromTime];
//            [newEntryContent setToTime: toTime];
//            [newEntryContent setPoster: self.rssEnclosure];
//            [newEntryContent setIsPublished: [NSNumber numberWithBool: YES]];
//            [newEntryContent setEventPublishedDate: pubDate];


            /*
            // Check if the update date has been changed since.
            //
            if ([[existingEntry updateDate]
                 compare: currentUpdateDateInNSDate] != NSOrderedSame) {
                
                // Debugging.
                //NSLog(@"didEndElement(): Existing entry found - needs to be updated.");
                
                
                // Because update date has been changed, all the content
                // might have been changed.
                //
                // Save everything into memory, except the Id.
                //
                [existingEntry setTitle:    [currentTitle   copy]];
                [existingEntry setAuthor:   [currentAuthor  copy]];
                [existingEntry setContent:  [currentContent copy]];
                [existingEntry setPublishDate: currentPublishDateInNSDate];
                [existingEntry setUpdateDate: currentUpdateDateInNSDate];
                
                
                // Commit the change to database.
                //
                NSError *error;
                
                if (![managedObjectContext save:&error]) {
                    
                    // Handle the error.
                    NSLog(@"Error occured in NewsViewController.m: parser:didEndElement(): Existing entry found:");
                    
                    if (error == nil) {
                        
                        NSLog(@"NSError is nil.");
                        
                    } else {
                        
                        NSLog(@"NSError description: %@", [error localizedDescription]);
                    }
                }
            }
             */
            
        }



        // @TODO
        // and if there was any changes since for existing entry.
        
        
    }
}



- (void)     parser:(NSXMLParser *)parser
    foundCharacters:(NSString *)string
{
    
    // Debugging.
    //NSLog(@"foundCharacters(): elem: %@, [%@]",
    //      self.currentElement, string
    //      );


    // A resolved bug:
    //
    // For some reason, the address of the currentAuthor 0x167290 happens to be the same as
    // the "author" attribute of the 1st blog entry (blogEntries[5].author).
    //
    // So blogEntries[5].author kept being over-written.
    //
    // This is because of copying the string by reference!
    //


    if ([self.currentElement isEqualToString: @"title"])
    {
        // Debugging.
        //NSLog(@"ViewController.m: foundCharacters(): title: %@", string);

        [self.rssTitle appendString: string];


    } else if ([self.currentElement isEqualToString: @"link"])
    {

        [self.rssLink appendString: string];


    } else if ([self.currentElement isEqualToString: @"description"])
    {
        
        [self.rssDescription appendString: string];


    } else if ([self.currentElement isEqualToString: @"author"])
    {
        
        [self.rssAuthor appendString: string];


    } else if ([self.currentElement isEqualToString: @"category"])
    {
        
        [self.rssCategory appendString: string];
        
        
    } else if ([self.currentElement isEqualToString: @"comments"])
    {
        
        [self.rssComments appendString: string];


    } else if ([self.currentElement isEqualToString: @"guid"])
    {
        
        [self.rssGuid appendString: string];
        
        
    } else if ([self.currentElement isEqualToString: @"pubDate"])
    {
        
        [self.rssPubDate appendString: string];
        
        
    }
    
    /*

    else if ([currentElement isEqualToString: @"guid"]) {
        
        [currentId appendString: string];
        
        

        
        
    } else if ([currentElement isEqualToString: @"category"]) {
        
        // Debugging.
        //NSLog(@"NewsViewController.m: foundCharacters(): cateogry: %@", string);
        
        
        // The <category>...</category> content are taken from the article's
        // labels. This will be used as the Author field.
        //
        [currentAuthor setString:@""];
        [currentAuthor appendString: string];
        
        
    } else if ([currentElement isEqualToString: @"description"]) {
        
        // Debugging.
        //NSLog(@"NewsViewController.m: foundCharacters(): description: %@", string);
        
        [currentContent appendString: string];
        
        
    } else if ([currentElement isEqualToString: @"pubDate"]) {
        
        // Debugging.
        //NSLog(@"NewsViewController.m: foundCharacters(): pubDate: %@", string);
        
        // A sample of the publish date is:
        //
        //          1234567890123456789012345
        // <pubDate>Thu, 26 Apr 2012 09:07:00 +0000</pubDate>
        //
        // Note about timezone:
        //
        // Even if the timezone in Blogspot has been set properly, pubDate
        // will not indicate timezone info but in GMT zone, it will say
        //
        // Thu, 03 May 2012 05:39:00 +0000
        // (Real time is 3/5/2012 3:39pm in Sydney)
        //
        [currentPublishDate appendString: [string substringToIndex:25]];
        
        
    } else if ([currentElement isEqualToString: @"guid"]) {
        
        [currentId appendString: string];
        
        
    } else if ([currentElement isEqualToString: @"atom:updated"]) {
        
        
        // Debugging.
        //NSLog(@"NewsViewController.m: foundCharacters(): atom:updated: %@", string);
        
        // A sample of the update date is:
        //
        //               1234567890123456789
        // <atom:updated>2012-04-26T02:44:40.024-07:00</atom:updated>
        //
        // Note about timezone:
        //
        // If the timezone in Blogspot has been set properly, it will return
        // a timezone indicator for the update date, as such:
        //
        // 2012-05-03T15:39:33.433+10:00
        // (Real time is 3/5/2012 3:39pm in Sydney)
        //
        [currentUpdateDate appendString: [string substringToIndex:19]];
     
    }

     */
}



- (void)parserDidEndDocument:(NSXMLParser *)parser
{

    // Debugging.
    //
    NSLog(@"ViewController.m: parserDidEndDocument");

    
    [self fetchDatabase];

    [self.tableview reloadData];
    
    
    // For some reason the reloaded data has some "corruption" in the 
    // last entry. Try delayed call using performSelector to see if it helps.
    //
    // - - -
    //
    // It did not help but keep for reference anyway.
    //
    /*
     [self.tableView performSelector:@selector(reloadData)
     withObject:nil
     afterDelay:10.0];
     */
    
    
    // Remove the overlay Activity Indicator.
    [self hideLoadingSign];
    
}



@end



