//
//  WebserviceManager.m
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import "WebserviceManager.h"

@implementation WebserviceManager

+(WebserviceManager *)sharedWebservices{
    static dispatch_once_t oncePred=0;
    static WebserviceManager *_sharedObj = nil;
    dispatch_once(&oncePred, ^{
        _sharedObj = [[WebserviceManager alloc]init];
    });
    return _sharedObj;
}

@end
