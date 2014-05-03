//
//  AnalyticsHelper.h
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 3/05/2014.
//  Copyright (c) 2014 Lamophone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalyticsHelper : NSObject

typedef enum {
    AnalyticsHelperEventTypeEventDetailsOpened = 0,
    AnalyticsHelperEventTypeEventDetailsBack,
    AnalyticsHelperEventTypeRefreshButtonTapped,
    AnalyticsHelperEventTypeChangeCategoryOpened,
    AnalyticsHelperEventTypeChangeCategoryBackUnchanged,
    AnalyticsHelperEventTypeChangeCategoryBackChanged
} AnalyticsHelperEventType;


/// Called at start up.
+ (void) startUp;

/// Log event without parameters..
+ (void) logEvent:(AnalyticsHelperEventType) eventType;

/// Log event with parameters.
+ (void) logEvent:(AnalyticsHelperEventType) eventType
   withParameters:(NSDictionary *)parameters;

@end
