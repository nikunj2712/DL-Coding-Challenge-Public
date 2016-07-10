//
//  WebserviceManager.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//


//This singleton class handles all web service related calls.

#import <Foundation/Foundation.h>
#import "NewCitiesModel.h"
#import "Cities+CoreDataProperties.h"
#import "HourlyForecasts+CoreDataProperties.h"
#import "Forecasts+CoreDataProperties.h"
#import "CurrentConditions+CoreDataProperties.h"

@interface WebserviceManager : NSObject

+(WebserviceManager *)sharedWebservices;

+(void)fetchCitiesFromURL:(NSString *)urlString withResponse:(void(^)(NSArray *arrayCities,NSString *errorRes))responseReceived;
+(void)saveCityUsingCityFullName:(NewCitiesModel *)objCity withCompletion:(void(^)(BOOL status,NSString *errorRes))status;

+(void)saveCityConditionsForQuery:(NSString *)stringQuery andCity:(Cities *)managedObjCity withCompletion:(void(^)(BOOL status,NSString *errorRes))status;


@end
