//
//  CCManager.m
//  Test
//
//  Created by tongleiming on 2019/4/24.
//  Copyright © 2019 tongleiming. All rights reserved.
//

#import "CCManager.h"

@implementation CCManager

+ (instancetype)sharedInstance {
    static CCManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CCManager alloc] init];
    });
    return instance;
}



@end
