//
//  CoredataManager.m
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import "CoredataManager.h"

@implementation CoredataManager

+(CoredataManager *)sharedCoreData{
    static dispatch_once_t oncePred=0;
    static CoredataManager *_sharedObj = nil;
    dispatch_once(&oncePred, ^{
        _sharedObj = [[CoredataManager alloc]init];
    });
    return _sharedObj;
}

@end
