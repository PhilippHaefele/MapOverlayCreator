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
    NSUInteger counter = 0;
    
    // Get the number of items (MKPointAnnotations) in the polyPoints array
    NSUInteger numOfPoints = [self.pointsArray count];
    
    // Define an overlay th
    CLLocationCoordinate2D  points[numOfPoints];
    
    for (id annotation in self.pointsArray)
    {
        if ([annotation isKindOfClass:[MKPointAnnotation class]])
        {
            MKPointAnnotation *point = (MKPointAnnotation *)annotation;
            
            points[counter] = point.coordinate;
            
            counter++;
        }
    }
    
    MKPolygon* poly = [MKPolygon polygonWithCoordinates:points count:numOfPoints];
    
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
