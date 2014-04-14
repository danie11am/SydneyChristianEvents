//
//  AppUtil.h
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 9/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject



+ (NSMutableArray *) convertCommentsFieldToDates: (NSString *) comments;

+ (NSDate *) convertTimestampToDate: (NSString *) timestamp;

+ (NSString *) convertToStringStartDate: (NSDate *) fromDate
                                 toDate: (NSDate *) toDate;

+ (int) getBlogIdFromLink: (NSString *) rssLink;


@end

