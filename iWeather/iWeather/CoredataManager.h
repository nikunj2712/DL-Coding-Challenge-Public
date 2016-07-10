//
//  CoredataManager.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

//This singleton class handles all core data stuff for storing data persistently

#import <Foundation/Foundation.h>
#import "NewCitiesModel.h"
#import "Cities+CoreDataProperties.h"
#import "HourlyForecasts+CoreDataProperties.h"
#import "Forecasts+CoreDataProperties.h"
#import "CurrentConditions+CoreDataProperties.h"
#import "ConditionsModel.h"

@interface CoredataManager : NSObject

+(CoredataManager *)sharedCoreData;

+(void)insertNewCity:(NewCitiesModel *)objCity withCompletion:(void(^)(BOOL isSaved, Cities *managedObjCity))completion;

+(void)fetchAllCitiesFromLocal:(void(^)(NSArray *arraySavedCities))responseData;

+(void)insertCurrentConditionsForCity:(Cities *)managedObjCity andData:(ConditionsModel *)modelConditions withCompletion:(void(^)(BOOL isSaved))completion;

+(void)deleteCityWithPlaceID:(NSString *)placeID withCompletion:(void(^)(BOOL isSucess))success;

+(Cities *)fetchCityForPlaceID:(NSString *)strPlaceID;

@end
