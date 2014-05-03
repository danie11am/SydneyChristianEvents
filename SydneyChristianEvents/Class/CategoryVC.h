//
//  CategoryVC.h
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 11/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Shows a list of event category options for user to filter event list entries.
 Categories are hardcoded in this class file and are supposed to match the event details in server:
 
 - All
 - Training
 - Youth
 - Mission
 - Revival
 - Family
 - Relationship
 */
@interface CategoryVC : UITableViewController

@property int selectedRow;
@property (strong) NSMutableArray *categoriesInEnglish;
@property (strong) NSMutableArray *categoriesInChinese;


@end
