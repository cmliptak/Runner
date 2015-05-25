//
//  PREConvert.h
//  Runner
//
//  Created by Maclab03 on 5/25/15.
//  Copyright (c) 2015 Liptak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PREConvert : NSObject

//Methods to create strings out of data; must be static methods
+(NSString *)distSg:(float)ms;
+(NSString *)secSg:(int)sec usingLongFormat:(BOOL)isLong;
+(NSString *)spdSg:(float)ms period:(int)sec;
@end
