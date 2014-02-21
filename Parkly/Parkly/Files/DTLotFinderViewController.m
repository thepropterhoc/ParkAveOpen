//
//  DTLotFinderViewController.m
//  Parkly
//
//  Created by Shelby Vanhooser on 2/19/14.
//  Copyright (c) 2014 DevTeam14. All rights reserved.
//

#import "DTLotFinderViewController.h"

@interface DTLotFinderViewController ()

@end

@implementation DTLotFinderViewController

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
  
  //[self setupMapView];
	// Do any additional setup after loading the view.
}

-(void)setupMapView
{
  MKMapCamera *camera = [[MKMapCamera alloc] init];
  //[camera setCenterCoordinate:self.theMap.userLocation.coordinate];
  [camera setAltitude:2000.0f];
  [self.theMap setCamera:camera animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  [mapView.camera setAltitude:2000.0f];
  [mapView.camera setCenterCoordinate:userLocation.coordinate];
}

- (IBAction)didSelectSegment:(UISegmentedControl *)sender {
  
}
@end
