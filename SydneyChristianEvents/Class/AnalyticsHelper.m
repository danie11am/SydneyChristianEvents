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
        case AnalyticsHelperEventTypeEventDetailsOpened: return @"event_details_opened"; break;
        case AnalyticsHelperEventTypeEventDetailsBack: return @"event_details_back"; break;
        case AnalyticsHelperEventTypeRefreshButtonTapped: return @"refresh_button_tapped"; break;
        case AnalyticsHelperEventTypeChangeCategoryOpened: return @"change_category_opened"; break;
        case AnalyticsHelperEventTypeChangeCategoryBackUnchanged: return @"change_category_back_unchanged"; break;
        case AnalyticsHelperEventTypeChangeCategoryBackChanged: return @"change_category_back_changed"; break;
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
