//
//  EventEntryCell.m
//  SydneyChristianEvents
//
//  Created by Daniel Lam on 9/05/13.
//  Copyright (c) 2013 Lamophone. All rights reserved.
//



#import "EventEntryCell.h"



@implementation EventEntryCell

const CGFloat titleLabelHeight = 20;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, 5, 300, titleLabelHeight)];
        titleLabel.font = [UIFont systemFontOfSize: 16];

        UILabel *dateLabel = [[UILabel alloc] initWithFrame: CGRectMake(10, titleLabelHeight + 5, 300, 20)];
        dateLabel.font = [UIFont systemFontOfSize: 11];
        dateLabel.textColor = [UIColor grayColor];

        self.eventTitleLabel = titleLabel;
        self.eventDateLabel = dateLabel;
        
        [self.contentView addSubview: self.eventTitleLabel];
        [self.contentView addSubview: self.eventDateLabel];

        /*
         Debugging.
        self.eventTitleLabel.backgroundColor = [UIColor yellowColor];
        self.eventDateLabel.backgroundColor = [UIColor blueColor];
        self.contentView.backgroundColor = [UIColor purpleColor];
        self.backgroundColor =  [UIColor orangeColor];
         */
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end


