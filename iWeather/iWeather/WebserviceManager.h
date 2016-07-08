//
//  WebserviceManager.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//


//This singleton class handles all web service related calls.

#import <Foundation/Foundation.h>

@interface WebserviceManager : NSObject

+(WebserviceManager *)sharedWebservices;

+(void)fetchCitiesFromURL:(NSString *)urlString withResponse:(void(^)(NSArray *arrayCities))responseReceived;
+(void)fetchLatitudeLongitudeFromCityFullName:(NSString *)strCityFullName withResponse:(void(^)(NSString *strTZId))responseData;

@end
