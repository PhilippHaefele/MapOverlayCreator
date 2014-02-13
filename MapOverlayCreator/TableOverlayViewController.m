//
//  TableOverlayViewController.m
//  MapOverlayCreator
//
//  Created by Philipp Häfele on 05.02.14.
//  Copyright (c) 2014 Philipp Häfele. All rights reserved.
//

#import "TableOverlayViewController.h"
#import "OverlayDetailViewController.h"

@interface TableOverlayViewController ()

@end

@implementation TableOverlayViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add edit button
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Allow multiple selection for deleting
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.overlays count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OverlayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *title = @"";
    
    id obj = [self.overlays objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[Overlay class]])
    {
        Overlay *tmpOverlay = (Overlay *)obj;
        
        title = tmpOverlay.name;
    }
    
    cell.textLabel.text = title;
    
    return cell;
}

 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return YES;
 }

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete)
     {
         // Delete the row from the data source
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         
         [self.overlays removeObjectAtIndex:indexPath.row];
     }
     
     [self.tableView reloadData];
 }

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"OverlayDetailSegue"])
    {
        UITableViewCell *cell = (UITableViewCell *)sender;
        
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        
        // Get TableOverlayViewController to set the overlay property in it
        OverlayDetailViewController *detailvc = (OverlayDetailViewController *)segue.destinationViewController;
            
        detailvc.overlay = [self.overlays objectAtIndex:ip.row];
        
    }
}


//################### Lazy instantiation ###################

- (NSMutableArray *)overlays
{
    if (!_overlays)
    {
        _overlays = [[NSMutableArray alloc]init];
    }
    
    return _overlays;
}

@end
