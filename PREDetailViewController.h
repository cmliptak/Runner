//
//  PREDetailViewController.h
//  Runner
//
//  Created by Maclab03 on 5/24/15.
//  Copyright (c) 2015 Liptak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Run;

@interface PREDetailViewController : UIViewController <MKMapViewDelegate>


@property (strong, nonatomic) Run *run;

//label references
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, weak) IBOutlet UILabel *finalDistLD;
@property (nonatomic, weak) IBOutlet UILabel *dateLD;
@property (nonatomic, weak) IBOutlet UILabel *timeLD;
@property (nonatomic, weak) IBOutlet UILabel *speedLD;

@end
