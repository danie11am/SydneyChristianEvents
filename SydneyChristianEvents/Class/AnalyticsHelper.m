//
//  AnalyticsHelper.m
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 3/05/2014.
//  Copyright (c) 2014 Lamophone. All rights reserved.
//

#import "Flurry.h"
#import "AnalyticsHelper.h"



@implementation AnalyticsHelper



// Review these settings before deployment.

static NSString * const FLURRY_API_KEY = @""; // To be replaced before submitting to app store.
static int const isFlurryDebugEnabled = YES;



+ (NSString *) eventStringForType:(AnalyticsHelperEventType) eventType {

    switch (eventType)
    {
            // Event list screen.

            // Tapped on an event from the list.
        case AnalyticsHelperEventTypeEventDetailsOpened: return @"event_details_opened"; break;
            
            // Tapped on refresh button in list screen.
        case AnalyticsHelperEventTypeRefreshButtonTapped: return @"refresh_button_tapped"; break;

            // Tapped on category button from toolbar.
        case AnalyticsHelperEventTypeChangeCategoryOpened: return @"change_category_opened"; break;
            
            // Event details screen.
            
            // Tapped on back button from an event details screen.
        case AnalyticsHelperEventTypeEventDetailsDismissed: return @"event_details_dismissed"; break;
            
            // Category screen.

            // Dismissed category selection screen by tapping on back or selected an item.
        case AnalyticsHelperEventTypeChangeCategoryDismissed: return @"change_category_dismissed"; break;

            // Tapped on a new category in category screen.
        case AnalyticsHelperEventTypeChangeCategoryChanged: return @"change_category_changed"; break;
        default: return @"undefined_event";
    }
}



+ (void) startUp {

    // iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry setDebugLogEnabled:isFlurryDebugEnabled];

    [Flurry setCrashReportingEnabled:YES];

    [Flurry startSession:FLURRY_API_KEY];
}



+ (void) logEvent:(AnalyticsHelperEventType) eventType
{
    [Flurry logEvent:[self eventStringForType:eventType]];
}



+ (void) logEvent:(AnalyticsHelperEventType) eventType
   withParameters:(NSDictionary *)parameters
{
    [Flurry logEvent:[self eventStringForType:eventType] withParameters:parameters];
}

@end
