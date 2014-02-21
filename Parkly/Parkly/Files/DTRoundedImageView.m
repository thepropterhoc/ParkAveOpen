//
//  DTRoundedImageView.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/19/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTRoundedImageView.h"

@implementation DTRoundedImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      
      
    }
  
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(void)didMoveToSuperview
{
  [self.layer setCornerRadius:self.frame.size.height/2];
  [self.layer setBorderColor:[[UIColor whiteColor] CGColor]];
  [self.layer setBorderWidth:5.0f];
}



@end
