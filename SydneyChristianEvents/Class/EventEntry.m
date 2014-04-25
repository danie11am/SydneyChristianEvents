//
//  EventEntry.m
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 9/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import "EventEntry.h"


@implementation EventEntry

@dynamic eventId;
@dynamic title;
@dynamic link;
@dynamic eventDescription;
@dynamic venue;
@dynamic category;
@dynamic poster;
@dynamic isPublished;
@dynamic eventPublishedDate;
@dynamic fromTime;
@dynamic toTime;


- (NSString *) description {
    
    NSString *str = @"EventEntry object: {\r";
    
    str = [NSString stringWithFormat: @"%@ \t eventId: {%@}, \r", str, self.eventId];
    str = [NSString stringWithFormat: @"%@ \t title: {%@}, \r", str, self.title];
    str = [NSString stringWithFormat: @"%@ \t link: {%@}, \r", str, self.link];
    // eventDescription not printed.
    str = [NSString stringWithFormat: @"%@ \t venue: {%@}, \r", str, self.venue];
    str = [NSString stringWithFormat: @"%@ \t category: {%@}, \r", str, self.category];
    str = [NSString stringWithFormat: @"%@ \t poster: {%@}, \r", str, self.poster];
    str = [NSString stringWithFormat: @"%@ \t isPublished: {%@}, \r", str, self.isPublished];
    str = [NSString stringWithFormat: @"%@ \t eventPublishedDate: {%@}, \r", str, self.eventPublishedDate];
    str = [NSString stringWithFormat: @"%@ \t fromTime: {%@}, \r", str, self.fromTime];
    str = [NSString stringWithFormat: @"%@ \t toTime: {%@}, \r", str, self.toTime];
    str = [NSString stringWithFormat: @"%@}", str];

    return str;
}

@end
