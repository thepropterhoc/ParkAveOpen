//
//  DTReceiptViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 3/9/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTReceiptViewController.h"

@interface DTReceiptViewController ()
@property (strong, nonatomic) IBOutlet UITextView *theTextView;

@end

@implementation DTReceiptViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self.theTextView setText:self.theReceipt];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender
{
  [self performSegueWithIdentifier:@"goToMain" sender:self];
  NSDictionary *options = @{
                            //MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                            MKLaunchOptionsMapTypeKey : @0,
                            MKLaunchOptionsMapCenterKey : [NSValue valueWithMKCoordinate: self.coordinate],
                            MKLaunchOptionsMapSpanKey : [NSValue valueWithMKCoordinateSpan: self.span]
                            };
  [self.theItem openInMapsWithLaunchOptions:options];
}

@end
