//
//  EventDetailsVC.m
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 10/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import "EventDetailsVC.h"
#import "EventEntry.h"
#import "AppUtil.h"


@interface EventDetailsVC ()

@end


@implementation EventDetailsVC



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {

        // Custom initialization

    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.

    NSLog(@"EventDetailsVC.m: viewDidLoad(): Started.");


    // UIWebView delegate has already been set to self, in Storyboard.


    // Set title.
    //
    self.title = self.eventEntry.title;


    //--------------------------------------------------------------------------

    // Open the text file which is a HTML string.
    //
    NSString* textFilePath =
    [[NSBundle mainBundle] pathForResource:@"event_details"
                                    ofType:@"html"
     ];
    
    NSMutableString* textFileContent = (NSMutableString *)
    [NSString stringWithContentsOfFile: textFilePath
                              encoding: NSUTF8StringEncoding
                                 error: NULL
     ];


    //--------------------------------------------------------------------------
    // Replace place-holders with actual event details.

    textFileContent = (NSMutableString *)
    [textFileContent
     stringByReplacingOccurrencesOfString: @"[[[EVENT_TITLE]]]"
     withString: self.eventEntry.title
     ];

    textFileContent = (NSMutableString *)
    [textFileContent
     stringByReplacingOccurrencesOfString: @"[[[EVENT_VENUE]]]"
     withString: self.eventEntry.venue
     ];
    
    textFileContent = (NSMutableString *)
    [textFileContent
     stringByReplacingOccurrencesOfString: @"[[[EVENT_DATES]]]"
     withString:
     [AppUtil convertToStringStartDate: self.eventEntry.fromTime
                                toDate: self.eventEntry.toTime
      ]
     ];
    
    textFileContent = (NSMutableString *)
    [textFileContent
     stringByReplacingOccurrencesOfString: @"[[[EVENT_CATEGORIES]]]"
     withString: self.eventEntry.category
     ];
    
    textFileContent = (NSMutableString *)
    [textFileContent
     stringByReplacingOccurrencesOfString: @"[[[EVENT_IMAGE]]]"
     withString: self.eventEntry.poster
     ];
    
    textFileContent = (NSMutableString *)
    [textFileContent
     stringByReplacingOccurrencesOfString: @"[[[EVENT_DESCRIPTION]]]"
     withString: self.eventEntry.eventDescription
     ];
    

    //NSLog(@"EventDetailsVC.m: viewDidLoad(): event poster: %@",
    //      self.eventEntry.poster
    //      );
    
    //--------------------------------------------------------------------------

    // Set the path so that image can be loaded.
    //
    NSString *path = [[NSBundle mainBundle] bundlePath];

    NSURL *baseURL = [NSURL fileURLWithPath:path];
    

    // Pass the string to the web view.
    //
    [self.eventWebView loadHTMLString: textFileContent
                              baseURL: baseURL
     ];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

