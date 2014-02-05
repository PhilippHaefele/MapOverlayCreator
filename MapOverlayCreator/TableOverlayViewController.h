//
//  TableOverlayViewController.h
//  MapOverlayCreator
//
//  Created by Philipp Häfele on 05.02.14.
//  Copyright (c) 2014 Philipp Häfele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Overlay.h"

@interface TableOverlayViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *overlays;

@end
