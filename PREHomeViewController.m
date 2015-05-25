//
//  PREHomeViewController.m
//  Runner
//
//  Created by Maclab03 on 5/24/15.
//  Copyright (c) 2015 Liptak. All rights reserved.
//

#import "PREHomeViewController.h"
#import "PRENewViewController.h"

@interface PREHomeViewController ()

@end

@implementation PREHomeViewController

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *nextController = [segue destinationViewController];
    if ([nextController isKindOfClass:[PRENewViewController class]]) {
        ((PRENewViewController *) nextController).managedObjectContext = self.managedObjectContext;
    }
}


@end
