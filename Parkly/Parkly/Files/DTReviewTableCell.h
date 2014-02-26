//
//  DTReviewTableCell.h
//  Parkly
//
//  Created by Shelby Vanhooser on 2/25/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTReviewTableCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *reviewText;
@property (strong, nonatomic) IBOutlet UILabel *reviewTitle;
@property (strong, nonatomic) IBOutlet UILabel *reviewValue;

@end
