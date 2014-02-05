//
//  MapOverlayCreatorViewController.m
//  MapOverlayCreator
//
//  Created by Philipp Häfele on 01.02.14.
//  Copyright (c) 2014 Philipp Häfele. All rights reserved.
//

#import "MapOverlayCreatorViewController.h"
#import "TableOverlayViewController.h"

@interface MapOverlayCreatorViewController ()

// Need this property because the annoataion array in mapView is unsorted
@property (nonatomic, strong) NSMutableArray *polyPoints;

@property (nonatomic, strong) NSMutableArray *overlays;

@end

@implementation MapOverlayCreatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set maptype to hybrid so we can see the buildings and also can orientate oneself to roads etc.
    self.mapView.mapType = MKMapTypeHybrid;
    
    // Show userlocation
    //self.mapView.showsUserLocation = YES;
    
#warning change this to something better or let the user save an own start location
    // create and set start Locarion
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(47.693888, 10.037259);
    
    self.mapView.region = MKCoordinateRegionMakeWithDistance(startCoordinate, 100, 100);
    
    // Create a gesture recognizer for long presses
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(createAnnotation:)];
    // Set minimum press time to half a second
    longPress.minimumPressDuration = 0.3;
    // Add gesture recognizer to mapView
    [self.mapView addGestureRecognizer:longPress];
}

- (void)updateMap
{

    // Remove all current overlays from mapView
    [self.mapView removeOverlays:self.mapView.overlays];
    
    // Add all overlays from overlays array to mapView
    for (id tmp in self.overlays)
    {
        if ([tmp isKindOfClass:[Overlay class]])
        {
            Overlay *tmpOverlay = (Overlay *)tmp;
            
            MKPolygon *tmpPoly = [tmpOverlay polyForOverlay];
            
            [self.mapView addOverlay: tmpPoly];
        }
    }
    
    // Remove all current annotations from mapView
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // Add all annotations from annotaions array to mapView
    [self.mapView addAnnotations:[self.polyPoints copy]];
    
}

// Gesture recognizers method for the long press on the mapView
- (void)createAnnotation:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        // Get the touch position / point in the mapView
        CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
        
        // Get the coordinates of the tapped point
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        // Create an annotaion and set the coordinate property
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        
        point.coordinate = touchMapCoordinate;
        
        // Add the annotation to the polyPoints array
        [self.polyPoints addObject:point];
        
        // Update mapView
        [self updateMap];
    }
}

//################# Create overlay handler #########################
#define ASK_NAME 1

// Function to create an overlay out of all current annotations in polyPoints (= mapView)
- (IBAction)createOverlay:(UIBarButtonItem *)sender
{
    if ([self.polyPoints count] > 0)
    {
        UIAlertView *message = [[UIAlertView alloc]initWithTitle:@"Add overlay"
                                                         message:@"Please enter a name for the Overlay"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                               otherButtonTitles:@"Add overlay", nil];
        
        message.tag = ASK_NAME;
        
        [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        [message show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ASK_NAME)
    {
        if (![alertView cancelButtonIndex] == buttonIndex)
        {
            // Create overlay out of annotations in polyPoints
            Overlay *tmpOverlay = [[Overlay alloc]initWithArrayOfAnnotations:self.polyPoints];
            
            NSString *name = [[alertView textFieldAtIndex:0] text];
            
            if (![name isEqualToString:@""])
            {
                tmpOverlay.name = name;
            }
            else
            {
                tmpOverlay.name = @"Noname";
            }
            
            tmpOverlay.color = [UIColor blueColor];
            
            // Add new overlay to overlays array
            [self.overlays addObject:tmpOverlay];
            
            // Remove all annotaions
            [self deleteAnnotations:nil];
            
            // Update mapView
            [self updateMap];
            
        }
    }
}

// Method to delete all annotations from the mapView
- (IBAction)deleteAnnotations:(UIBarButtonItem *)sender
{
    // Delete all annotations from annotation array
    self.polyPoints = nil;
    
    // Update mapView
    [self updateMap];
}

- (IBAction)deleteLastAnnotation:(UIBarButtonItem *)sender
{
    // Remove last annotation from annotation array
    [self.polyPoints removeLastObject];
    
    // Update mapView
    [self updateMap];
}

- (IBAction)delteOverlays:(UIBarButtonItem *)sender
{
    // Remove all overlays from overlays array
    self.overlays = nil;
    
    // Update mapView
    [self updateMap];
}


#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
    
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
    }
#warning need better image for annotation
    annotationView.image = [UIImage imageNamed:@"pin123"];
    annotationView.centerOffset = CGPointMake(0, -16);
    annotationView.annotation = annotation;
    
    return annotationView;
}

// Method that creates the OverlayView
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonView *polyView = [[MKPolygonView alloc] initWithPolygon:(MKPolygon *)overlay];
        
        polyView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        polyView.strokeColor = [UIColor blueColor];
        polyView.lineWidth = 3;
        
        return polyView;
    }
    return nil;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"OverlayTableSegue"])
    {
        // Get TableOverlayViewController to set the overlay property in it
        TableOverlayViewController *tablevc = (TableOverlayViewController *)segue.destinationViewController;
        
        tablevc.overlays = self.overlays;
    }
}

//################### Lazy instantiation ###################

-(NSMutableArray *)polyPoints
{
    if (!_polyPoints)
    {
        _polyPoints = [[NSMutableArray alloc]init];
    }
    
    return _polyPoints;
}

- (NSMutableArray *)overlays
{
    if (!_overlays)
    {
        _overlays = [[NSMutableArray alloc]init];
    }
    
    return _overlays;
}

@end
