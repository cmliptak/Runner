//
//  PRENewViewController.m
//  Runner
//
//  Created by Maclab03 on 5/24/15.
//  Copyright (c) 2015 Liptak. All rights reserved.
//

#import "PRENewViewController.h"
#import "PREDetailViewController.h"
#import "Run.h"

//variables
static NSString * const segueDetails = @"RDetails";

@interface PRENewViewController () <UIActionSheetDelegate>

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
    // Do any additional setup after loading the view.

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//****************************************************************************************************
//Only show the prompt label and start button; notify view controller of what will appear
//****************************************************************************************************
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //hide
    self.timeL.text = @"";
    self.timeL.hidden = YES;
    self.distL.hidden = YES;
    self.speedL.hidden = YES;
    self.stopBtn.hidden = YES;
    
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
    [[segue destinationViewController] setRun:self.run];
}
@end
