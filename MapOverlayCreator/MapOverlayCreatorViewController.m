//
//  MapOverlayCreatorViewController.m
//  MapOverlayCreator
//
//  Created by Philipp Häfele on 01.02.14.
//  Copyright (c) 2014 Philipp Häfele. All rights reserved.
//

#import "MapOverlayCreatorViewController.h"

@interface MapOverlayCreatorViewController ()

// Need this property because the annoataion array in mapView is unsorted
@property (nonatomic, strong) NSMutableArray *polyPoints;

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
    
#warning change this to something better or let the user save an own location
    // create and set start Locarion
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(47.693888, 10.037259);
    
    self.mapView.region = MKCoordinateRegionMakeWithDistance(startCoordinate, 100, 100);
    
    // Create a gesture recognizer for long presses
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    // Set minimum press time to half a second
    longPress.minimumPressDuration = 0.3;
    // Add gesture recognizer to mapView
    [self.mapView addGestureRecognizer:longPress];
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


// Gesture recognizers method for the long press on the mapView
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
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
        
        // Add the annotation to the map
        [self.mapView addAnnotation:point];
    }
}

// Method to delete all annotations from the mapView
- (IBAction)deleteAnnotations:(UIBarButtonItem *)sender
{
    for (id annotation in self.mapView.annotations)
    {
        if ([annotation isKindOfClass:[MKPointAnnotation class]])
        {
            [self.mapView removeAnnotation:annotation];
        }
    }
}

// Function to create an overlay out of all current annotations in polyPoints (= mapView)
- (IBAction)createOverlay:(UIBarButtonItem *)sender
{
    NSUInteger counter = 0;
    
    // Get the number of items (MKPointAnnotations) in the polyPoints array
    NSUInteger numOfPoints = [self.polyPoints count];
    
    // Define an overlay th
    CLLocationCoordinate2D  points[numOfPoints];
    
    for (id annotation in self.polyPoints)
    {
        if ([annotation isKindOfClass:[MKPointAnnotation class]])
        {
            MKPointAnnotation *point = (MKPointAnnotation *)annotation;
            
            points[counter] = point.coordinate;
            
            counter++;
        }
    }
    
    MKPolygon* poly = [MKPolygon polygonWithCoordinates:points count:numOfPoints];
    
    poly.title = @"Poly 1";
    
    
    [self deleteAnnotations:nil];
    
    [self.mapView addOverlay:poly];
}

- (IBAction)delteOverlays:(UIBarButtonItem *)sender
{
    [self.mapView removeOverlays:self.mapView.overlays];
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

@end
