//
//  PRENewViewController.m
//  Runner
//
//  Created by Maclab03 on 5/24/15.
//  Copyright (c) 2015 Liptak. All rights reserved.
//

#import "PRENewViewController.h"
#import <CoreLocation/CoreLocation.h>


//variables
static NSString * const segueDetails = @"RDetails";

@interface PRENewViewController ()

@end

@implementation PRENewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        self.mapView.hidden = YES;
    // Do any additional setup after loading the view.

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


//****************************************************************************************************
//Only show the prompt label and start button; notify view controller of what will appear
//****************************************************************************************************
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.timer invalidate]; //stop updating
    
    //hide
    self.timeL.text = @"";
    self.timeL.hidden = YES;
    self.distL.hidden = YES;
    self.speedL.hidden = YES;
    self.stopBtn.hidden = YES;
    self.mapView.hidden = YES;

    
    //show
    self.startBtn.hidden = NO;
    self.promptL.hidden = NO;
    self.prompt.hidden = NO;

}

//****************************************************************************************************
//  Action handler for start button; hide start info show other properties
//****************************************************************************************************
-(IBAction)startAction:(id)sender{

    //hide
    self.startBtn.hidden = YES;
    self.promptL.hidden = YES;
    self.prompt.hidden = YES;
    
    //show
    self.timeL.hidden = NO;
    self.distL.hidden = NO;
    self.speedL.hidden = NO;
    self.stopBtn.hidden = NO;
    self.mapView.hidden = NO;

    
    //begin run; resets fields
    self.secs = 0;
    self.dist = 0;
    self.savedLoc = [NSMutableArray array];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(1.0) target:self
                                                selector:@selector(updateLabels) userInfo:nil repeats:YES];
    [self updateLocation];

}
//****************************************************************************************************
//  Action handler for stop button; propmpt for the action dialog
//****************************************************************************************************
-(IBAction)stopAction:(id)sender{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
                                                    cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save", @"Delete", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view];
}

//****************************************************************************************************
//  Method for the action sheet
//****************************************************************************************************
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // if(save);
    if (buttonIndex == 0) {
        [self saveRun];
        [self performSegueWithIdentifier:segueDetails sender:nil];
        
    }//end if save
    else
        // if(delete); go back home
        if(buttonIndex == 1) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }//end if(delete)
}

//****************************************************************************************************
//   When this method is called it sets up the DetailsView with the current info
//****************************************************************************************************
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [[segue destinationViewController] setRun:self.run];
}
//***********************************************************************************************************************
//  pass current values to the methods of PREConvert to pull the strings and assign them to propper labels;
//  every time this method is called the labels are updated
//***********************************************************************************************************************
- (void)updateLabels
{
    self.secs++;
    
    self.timeL.text = [NSString stringWithFormat:@"Time: %@",  [PREConvert secSg:self.secs usingLongFormat:NO]];
    self.distL.text = [NSString stringWithFormat:@"Distance: %@", [PREConvert distSg:self.dist]];
    self.speedL.text = [NSString stringWithFormat:@"Speed: %@",  [PREConvert spdSg:self.dist period:self.secs]];
}
//***********************************************************************************************************************
//  Update the location
//***********************************************************************************************************************
- (void)updateLocation
{
    // Create the location manager
    if (self.loc == nil) {
        self.loc = [[CLLocationManager alloc] init];
    }
    
    self.loc.delegate = self;// sets the delegate to this class; it tells where to send location updates
    self.loc.desiredAccuracy = kCLLocationAccuracyBest;
    self.loc.activityType = CLActivityTypeFitness;
    
    // Movement threshold for new events.
    self.loc.distanceFilter = 10; // meters
    
    //tell manager to get updates on the location
    [self.loc startUpdatingLocation];
}
//***********************************************************************************************************************
//  This gets the updates from the Location Manager
//  method is called whenever there are new updates that can be given
//  Obtain the latitude, longitude, altitude, and timestamp from CLLocation
//***********************************************************************************************************************

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)savedLoc
{
    for (CLLocation *newLocation in savedLoc) {
        //if (newLocation.horizontalAccuracy < 20) {
            NSDate *eventDate = newLocation.timestamp;
            NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
            
            if (abs(howRecent) < 10.0 && newLocation.horizontalAccuracy < 20) {
                
            // update distance
            if (self.savedLoc.count > 0) {
                self.dist += [newLocation distanceFromLocation:self.savedLoc.lastObject];
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.savedLoc.lastObject).coordinate;
                coords[1] = newLocation.coordinate;
                
                MKCoordinateRegion region =
                MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500);
                [self.mapView setRegion:region animated:YES];
                
                [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
                
            }
            
            [self.savedLoc addObject:newLocation];
        }
    }
}
//***********************************************************************************************************************
//  Each run is saved separately
//  Stop reading locations and save
//***********************************************************************************************************************

- (void)saveRun
{
    //create a Run object
    Run *newRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run"
                                                inManagedObjectContext:self.managedObjectContext];
    
    newRun.path = [NSNumber numberWithFloat:self.dist];
    newRun.duration = [NSNumber numberWithInt:self.secs];
    newRun.time = [NSDate date];
    
    NSMutableArray *locationArray = [NSMutableArray array];
    for (CLLocation *loc in self.savedLoc) {
        //create Location object
        Location *locObject = [NSEntityDescription insertNewObjectForEntityForName:@"Location"
                                                                 inManagedObjectContext:self.managedObjectContext];
        
        locObject.time = loc.timestamp;
        locObject.lati = [NSNumber numberWithDouble:loc.coordinate.latitude];
        locObject.longi = [NSNumber numberWithDouble:loc.coordinate.longitude];
        
        [locationArray addObject:locObject];
    }
    
    newRun.locations = [NSOrderedSet orderedSetWithArray:locationArray];
    self.run = newRun;
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
//***********************************************************************************************************************
//
//***********************************************************************************************************************
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blueColor];
        aRenderer.lineWidth = 5;
        return aRenderer;
    }
    return nil;
}

//***********************************************************************************************************************
//
//***********************************************************************************************************************
@end
