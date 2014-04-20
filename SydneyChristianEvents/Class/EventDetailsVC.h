//
//  EventDetailsVC.h
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 10/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EventEntry;


@interface EventDetailsVC : UIViewController

@property (strong, nonatomic) UIWebView *eventWebView;
@property (strong, nonatomic) EventEntry *eventEntry;

@end

