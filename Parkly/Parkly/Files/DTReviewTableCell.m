//
//  DTReviewTableCell.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/25/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTReviewTableCell.h"

@implementation DTReviewTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithReview:(DTReview*)review
{
  self.reviewText.text = review.body;
  self.reviewTitle.text = review.title;
  self.reviewValue.text = [NSString stringWithFormat:@"%d", review.stars];
  self.dateLabel.text = review.date;
  self.authorLabel.text = [NSString stringWithFormat:@"- %@", review.reviewer_id];
}

@end
