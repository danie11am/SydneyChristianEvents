//
//  CategoryVC.h
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 11/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 Categories of events include:
 
 All
 Training
 Youth
 Mission
 Revival
 Family
 Relationship

 */
 
@interface CategoryVC : UITableViewController

@property int selectedRow;
@property (strong) NSMutableArray *categories;
@property (strong) NSMutableArray *categoriesInChinese;


@end
