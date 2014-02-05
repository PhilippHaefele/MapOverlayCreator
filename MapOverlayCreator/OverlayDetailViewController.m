//
//  OverlayDetailViewController.m
//  MapOverlayCreator
//
//  Created by Philipp Häfele on 05.02.14.
//  Copyright (c) 2014 Philipp Häfele. All rights reserved.
//

#import "OverlayDetailViewController.h"

@interface OverlayDetailViewController ()

@end

@implementation OverlayDetailViewController

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
    
    // Set title of nav controller to name of overlay
    self.navigationItem.title = self.overlay.name;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
