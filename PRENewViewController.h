//
//  PRENewViewController.h
//  Runner
//
//  Created by Maclab03 on 5/24/15.
//  Copyright (c) 2015 Liptak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PREDetailViewController.h"
#import "PREConvert.h"
#import "Run.h"
#import "Location.h"
#import <MapKit/MapKit.h>

@interface PRENewViewController : UIViewController <UIActionSheetDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) Run *run;

//label references
@property (nonatomic, weak) IBOutlet UILabel *promptL;
@property (nonatomic, weak) IBOutlet UILabel *timeL;
@property (nonatomic, weak) IBOutlet UILabel *distL;
@property (nonatomic, weak) IBOutlet UILabel *speedL;
@property (weak, nonatomic) IBOutlet UIImageView *prompt;

//button references
@property (nonatomic, weak) IBOutlet UIButton *startBtn;
@property (nonatomic, weak) IBOutlet UIButton *stopBtn;


@property int secs;
@property float dist;
@property (nonatomic, strong) CLLocationManager *loc;
@property (nonatomic, strong) NSMutableArray *savedLoc;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

//button action
-(IBAction)startAction:(id)sender;
-(IBAction)stopAction:(id)sender;

@end
