//
//  Location.h
//  Runner
//
//  Created by Maclab03 on 5/24/15.
//  Copyright (c) 2015 Liptak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSNumber * lati;
@property (nonatomic, retain) NSNumber * longi;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSManagedObject *run;

@end
