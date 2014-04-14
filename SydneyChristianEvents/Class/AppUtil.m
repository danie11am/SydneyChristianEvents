//
//  AppUtil.m
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 9/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import "AppUtil.h"

@implementation AppUtil




/**
 *******************************************************************************
 
 Given "comments" field, which is from the server and look something like
 "1363386600 to 1363413600", convert to NSDate's.

 Sometimes there is only one number, in that case convert only one.

 */
+ (NSMutableArray *) convertCommentsFieldToDates: (NSString *) comments
{

    NSMutableArray *dates = [NSMutableArray array];


    // Trim the white space.
    //
    comments =
    [comments stringByTrimmingCharactersInSet:
     [NSCharacterSet whitespaceAndNewlineCharacterSet]
     ];

    NSArray *timestamps =
    [comments componentsSeparatedByString: @" to "];
    
    //NSLog(@"AppUtil.m: convertCommentsFieldToDates(): comments: [%@]",
    //      comments
    //      );

    for (NSString *timestamp in timestamps)
    {
        NSDate *date = [AppUtil convertTimestampToDate: timestamp];

        // Timestamp is originally in standard time. Need to set the timezone
        // when displaying them.
        //
        //NSLog(@"timestamp str: %@, NSDate: %@", timestamp, date);
        
        [dates addObject: date];
    }

    
    return dates;

}



/**
 *******************************************************************************
 */
+ (NSDate *) convertTimestampToDate: (NSString *) timestamp
{

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:
                    (NSTimeInterval) [timestamp doubleValue]
                    ];

    return date;
}



/**
 *******************************************************************************
 */
+ (BOOL) areDatesEqualDate1: (NSDate *) date1
                      date2: (NSDate *) date2
{
    // Check if two dates are the same.
    NSDateFormatter *dateComparisonFormatter = [[NSDateFormatter alloc] init];
     
    [dateComparisonFormatter setDateFormat:@"yyyy-MM-dd"];
    
    BOOL isEqual = NO;
    
    if ([[dateComparisonFormatter stringFromDate:date1] isEqualToString:
         [dateComparisonFormatter stringFromDate:date2]]
        )
    {
        isEqual = YES;
    }
    
    return isEqual;
}



/**
 *******************************************************************************
 */
+ (NSString *) convertToStringStartDate: (NSDate *) fromDate
                                 toDate: (NSDate *) toDate
{

    NSDateFormatter * startDateFormatter = [[NSDateFormatter alloc] init];

    // Set the style for the time.
    //
    // Short format: 6:00 PM
    //
    //[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [startDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    // Set the style for the date.
    //
    // Long style:   9 May 2013
    // Medium style: 09/05/2013
    // Short style:  9/5/13
    //
    //[startDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [startDateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //[startDateFormatter setDateStyle:NSDateFormatterLongStyle];


    // Set timezone to re-adjust the time.
    //
    // Without setting timeZone, the default timezone will be used, which
    // appears to be correct.
    //
    // [dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    //
    // JST - Asia/Tokyo time.
    //
    // [dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"JST"]];

    NSDateFormatter * dayOfWeekFormatter = [[NSDateFormatter alloc] init];

    [dayOfWeekFormatter setDateFormat:@"EEE"];
    

    NSString *fromDateStr =
    [NSString stringWithFormat:@"%@ %@",
     [dayOfWeekFormatter stringFromDate: fromDate],
     [startDateFormatter stringFromDate: fromDate]
     ];


    if (toDate == nil)// NULL)
    {
        return fromDateStr;
    }

    // Check if the End date is on the same day as Start date.
    // Format the End date accordingly.

    NSDateFormatter * endDateFormatter = [[NSDateFormatter alloc] init];

    if ([AppUtil areDatesEqualDate1: fromDate
                              date2: toDate
         ]
        )
    {
        // If they are the same, only show time for the end date.
        //
        [endDateFormatter setTimeStyle:NSDateFormatterShortStyle];

    } else
    {
        // If they are NOT the same, show the whole date and time.
        //
        //[endDateFormatter setDateStyle:NSDateFormatterLongStyle];
        [endDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [endDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        
    }

    NSString *wholeDateStr =
    [NSString stringWithFormat:@"%@ - %@",
     fromDateStr,
     [endDateFormatter stringFromDate: toDate]
     ];


    return wholeDateStr;
}



/**
 *******************************************************************************
 */
+ (int) getBlogIdFromLink: (NSString *) rssLink
{
    
    NSArray *separatedStrs = [rssLink componentsSeparatedByString: @"/"];
    
    NSString *blogIdStr = [separatedStrs lastObject];
    
    int blogId = 0;
    
    if (blogIdStr != NULL)
    {
        blogId = [blogIdStr intValue];
    }

    //NSLog(@"AppUtil.m: getBlogIdFromLink(): blogId: %i", blogId);


    return blogId;
    
}



@end


