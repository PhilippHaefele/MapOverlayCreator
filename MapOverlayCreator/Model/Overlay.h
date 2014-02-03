//
//  Overlay.h
//  MapOverlayCreator
//
//  Created by Philipp Häfele on 03.02.14.
//  Copyright (c) 2014 Philipp Häfele. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Overlay : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIColor *color;

- (Overlay *)initWithArrayOfAnnotations:(NSMutableArray *)annotations;

- (MKPolygon *)polyForOverlay;

- 

@end
