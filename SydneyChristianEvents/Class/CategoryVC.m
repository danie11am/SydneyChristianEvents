//
//  CategoryVC.m
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 11/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//

#import "CategoryVC.h"

@interface CategoryVC ()

@end

@implementation CategoryVC



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self) {
        //NSLog(@"CategoryVC.m: initWithStyle(): started.");
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"CategoryVC.m: viewDidLoad(): started.");

    self.categoriesInEnglish =
    [NSMutableArray arrayWithObjects:
     @"All",
     @"Training",
     @"Youth",
     @"Mission",
     @"Revival",
     @"Family",
     @"Relationship",
     nil
     ];

    self.categoriesInChinese =
    [NSMutableArray arrayWithObjects:
     @"全部",
     @"訓練",
     @"青年",
     @"佈道",
     @"培靈",
     @"家庭",
     @"關係",
     nil
     ];

    int categoryId = (int) [[NSUserDefaults standardUserDefaults] integerForKey: @"savedCategory"];
    self.selectedRow = categoryId;


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)didMoveToParentViewController:(UIViewController *)parent
{
    [super didMoveToParentViewController:parent];

    // parent is nil if this view controller was removed, i.e. VC poped.
    if (parent == nil) {
        [AnalyticsHelper logEvent:AnalyticsHelperEventTypeChangeCategoryDismissed];
    }
}



#pragma mark - Table view data source



- (NSString *)    tableView: (UITableView *)tableView
    titleForHeaderInSection: (NSInteger)section
{

    return @"請選擇類別:";

}



/** Return the number of sections. */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // There is only 1 section.
    return 1;
}



/** Return the number of rows in the section. */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categoriesInChinese count];
}



- (UITableViewCell *)tableView: (UITableView *)tableView
         cellForRowAtIndexPath: (NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CategoryCell";
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    // Configure the cell...
    // For some reason it seems that it is ok not to call them sometimes.
    if (cell == nil) {

        NSLog(@"CategoryVC.m: cellForRowAtIndexPath(): cell is null.");

        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1
                                      reuseIdentifier: cellIdentifier
                ];
        
        // Row should not be selectable. Actions go through buttons.
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

	// Check if this cell needs to be marked.
	if (indexPath.row == self.selectedRow)
    {
		// Set the cell to have checkmark.
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		// Set the cell to CLEAR checkmark.
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

    NSString *categoryInChinese = [self.categoriesInChinese objectAtIndex: indexPath.row];
    cell.textLabel.text = categoryInChinese;

    return cell;

}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/



/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */

    // Set the selected cell to have checkmark.
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;

    // Clear the mark of the previous cell.
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.selectedRow inSection:0];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;

    // Remember the new selection.
    self.selectedRow = (int) indexPath.row;

    // Modify the User Defaults database.
    [[NSUserDefaults standardUserDefaults] setInteger: self.selectedRow
                                               forKey: @"savedCategory"
     ];

    // Track usage.
    NSString *categoryInChinese = [self.categoriesInChinese objectAtIndex: self.selectedRow];
    NSString *categoryInEnglish = [self.categoriesInEnglish objectAtIndex: self.selectedRow];
    NSDictionary *eventParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                 categoryInChinese, @"category_chinese",
                                 categoryInEnglish, @"category_english",
                                 nil
                                 ];
    [AnalyticsHelper logEvent:AnalyticsHelperEventTypeChangeCategoryChanged
               withParameters:eventParams
     ];

    
    // Make the change effective immediately.
    [[NSUserDefaults standardUserDefaults] synchronize];
	[tableView deselectRowAtIndexPath:indexPath	animated:YES];

    [self.navigationController popViewControllerAnimated: YES];
}



@end


