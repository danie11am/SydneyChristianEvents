//
//  EventEntry.h
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 9/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * poster;
@property (nonatomic, retain) NSNumber * isPublished;
@property (nonatomic, retain) NSDate * eventPublishedDate;
@property (nonatomic, retain) NSDate * fromTime;
@property (nonatomic, retain) NSDate * toTime;

@end
