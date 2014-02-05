//
//  Overlay.m
//  MapOverlayCreator
//
//  Created by Philipp Häfele on 03.02.14.
//  Copyright (c) 2014 Philipp Häfele. All rights reserved.
//

#import "Overlay.h"

@interface Overlay()

@property (nonatomic, strong) NSMutableArray *pointsArray;

@end


@implementation Overlay

- (Overlay *)initWithArrayOfAnnotations:(NSMutableArray *)annotations
{
    self = [super init];
    
    if (self)
    {
        self.pointsArray = annotations;
    }
    
    return self;
}

- (MKPolygon *)polyForOverlay
{
    // Get the number of items (MKPointAnnotations) in the polyPoints array
    NSUInteger numOfPoints = [self.pointsArray count];
    
    // Define an overlay th
    CLLocationCoordinate2D  points[numOfPoints];
    //MKMapPoint  points[numOfPoints];
    
    for (int i = 0; i < [self.pointsArray count]; i++)
    {
        id annotation = [self.pointsArray objectAtIndex:i];
        
        if ([annotation isKindOfClass:[MKPointAnnotation class]])
        {
            MKPointAnnotation *point = (MKPointAnnotation *)annotation;
            
            points[i] = point.coordinate;
        }
    }
    
    // Create polygon
    MKPolygon* poly = [MKPolygon polygonWithCoordinates:points count:numOfPoints];
    
    // Set title of polygon
    poly.title = self.name;
    
    return poly;
}

//################### Lazy instantiation ###################

- (NSMutableArray *)pointsArray
{
    if (!_pointsArray)
    {
        _pointsArray = [[NSMutableArray alloc]init];
    }
    
    return _pointsArray;
}

- (NSString *)name
{
    if (!_name)
    {
        _name = [[NSString alloc]init];
    }
    
    return _name;
}

- (UIColor *)color
{
    if (!_color)
    {
        _color = [[UIColor alloc]init];
    }
    
    return _color;
}

@end
