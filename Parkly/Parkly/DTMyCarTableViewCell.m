//
//  DTMyCarTableViewCell.m
//  Park Ave
//
//  Created by Shelby Vanhooser on 4/8/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTMyCarTableViewCell.h"

@implementation DTMyCarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initWithCar:(DTCar *)car
{
  self.makeLabel.text = car.make;
  self.modelLabel.text = car.model;
  self.yearLabel.text = car.year;
  self.colorLabel.text = car.color;
  self.tagLabel.text = car.plate;
}

@end
