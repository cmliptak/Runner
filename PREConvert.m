//
//  PREConvert.m
//  Runner
//
//  Created by Maclab03 on 5/25/15.
//  Copyright (c) 2015 Liptak. All rights reserved.
//

//**********************************************************************************************
//  This class is used to convert the units to strings
//**********************************************************************************************
#import "PREConvert.h"

float const msMiles = 1609.344;

@implementation PREConvert

//**********************************************************************************************
// returns the string for distance
//**********************************************************************************************
+(NSString *)distSg:(float)ms{

    NSString *units = @"mi";
    return [NSString stringWithFormat:@"%.2f %@", (ms / msMiles), units];
}

//**********************************************************************************************
//  Returns the string for time
//**********************************************************************************************
+(NSString *)secSg:(int)sec usingLongFormat:(BOOL)isLong{
    
    int secs = sec;
    int hrs = secs / 3600;// convert from seconds to hours
    
    secs = secs - hrs * 3600;
    
    int mins = secs / 60;
    
    secs = secs - mins * 60;
    
    if (isLong){
        
        if (hrs > 0){
            return [NSString stringWithFormat:@"%i hr %i min %i sec", hrs, mins, secs];
        }
        else
            if (mins > 0){
                return [NSString stringWithFormat:@"%i min %i sec", mins, secs];
            }
            else{
                return [NSString stringWithFormat:@"%i sec", secs];
            }
    }//end if(isLong)
    else{
        if (hrs > 0){
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hrs, mins, secs];
        }
        else
            if (mins > 0) {
                return [NSString stringWithFormat:@"%02i:%02i", mins, secs];
            }
            else{
                return [NSString stringWithFormat:@"00:%02i", secs];
            }
    }//end else if(hrs>0)
}//end secSg

//**********************************************************************************************
//  Returns string for speed
//**********************************************************************************************
+(NSString *)spdSg:(float)ms period:(int)sec{
    
    if (sec == 0 || ms == 0) {
        return @"0";
    }
    
    //variables
    float speed = sec / ms;
    NSString *units = @"min/mi";

    int spdMin = (int) ((speed * msMiles) / 60);
    int spdSec = (int) (speed * msMiles - (spdMin*60));
    
    return [NSString stringWithFormat:@"%i:%02i %@", spdMin, spdSec, units];
}//end spdSg

@end
