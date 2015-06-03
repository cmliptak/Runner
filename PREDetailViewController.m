//
//  PREDetailViewController.m
//  Runner
//
//  Created by Maclab03 on 5/24/15.
//  Copyright (c) 2015 Liptak. All rights reserved.
//

#import "PREDetailViewController.h"
#import <MapKit/MapKit.h>
#import "PREConvert.h"
#import "Run.h"
#import "Location.h"

@interface PREDetailViewController ()<MKMapViewDelegate>
- (void)configureView;
@end

@implementation PREDetailViewController

#pragma mark - Managing the detail item
//**********************************************************************************************
//
//**********************************************************************************************
- (void)setRun:(Run *)run
{
    if (_run != run) {
        _run = run;
        [self configureView];
    }
    
}
//**********************************************************************************************
//
//**********************************************************************************************
- (void)configureView
{
    self.finalDistLD.text = [PREConvert distSg:self.run.path.floatValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dateLD.text = [formatter stringFromDate:self.run.time];
    
    self.timeLD.text = [NSString stringWithFormat:@"Time: %@",  [PREConvert secSg:self.run.duration.intValue usingLongFormat:YES]];
    
    self.speedLD.text = [NSString stringWithFormat:@"Speed: %@",  [PREConvert spdSg:self.run.duration.floatValue period:self.run.duration.intValue]];

    [self loadMap];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}
//**********************************************************************************************
//
//**********************************************************************************************
- (MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;
    Location *initialLoc = self.run.locations.firstObject;
    
    float minLat = initialLoc.lati.floatValue;
    float minLng = initialLoc.longi.floatValue;
    float maxLat = initialLoc.lati.floatValue;
    float maxLng = initialLoc.longi.floatValue;
    
    for (Location *location in self.run.locations) {
        if (location.lati.floatValue < minLat) {
            minLat = location.lati.floatValue;
        }
        if (location.longi.floatValue < minLng) {
            minLng = location.longi.floatValue;
        }
        if (location.lati.floatValue > maxLat) {
            maxLat = location.lati.floatValue;
        }
        if (location.longi.floatValue > maxLng) {
            maxLng = location.longi.floatValue;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 1.1f; // 10% padding
    region.span.longitudeDelta = (maxLng - minLng) * 1.1f; // 10% padding
    
    return region;
}
//**********************************************************************************************
//
//**********************************************************************************************

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blackColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}
//**********************************************************************************************
//
//**********************************************************************************************
- (MKPolyline *)polyLine {
    
    CLLocationCoordinate2D coords[self.run.locations.count];
    
    for (int i = 0; i < self.run.locations.count; i++) {
        Location *location = [self.run.locations objectAtIndex:i];
        coords[i] = CLLocationCoordinate2DMake(location.lati.doubleValue, location.longi.doubleValue);
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:self.run.locations.count];
}
//**********************************************************************************************
//
//**********************************************************************************************
- (void)loadMap
{
    if (self.run.locations.count > 0) {
        
        self.mapView.hidden = NO;
        
        // set the map bounds
        [self.mapView setRegion:[self mapRegion]];
        
        // make the line(s!) on the map
        [self.mapView addOverlay:[self polyLine]];
        
    } else {
        
        // no locations were found!
        self.mapView.hidden = YES;
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Sorry, this run has no locations saved."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}
@end

