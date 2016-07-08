//
//  CoredataManager.m
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

@import CoreData;
#import "CoredataManager.h"
#import "Cities+CoreDataProperties.h"
#import "HourlyForecasts+CoreDataProperties.h"
#import "Forecasts+CoreDataProperties.h"
#import "CurrentConditions+CoreDataProperties.h"

@implementation CoredataManager

+(CoredataManager *)sharedCoreData{
    static dispatch_once_t oncePred=0;
    static CoredataManager *_sharedObj = nil;
    dispatch_once(&oncePred, ^{
        _sharedObj = [[CoredataManager alloc]init];
    });
    return _sharedObj;
}

+ (NSManagedObjectContext *)managedObjectContext
{
    
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    
    return context;
}

+(void)insertNewCity:(NewCitiesModel *)objCity withCompletion:(void(^)(BOOL isSaved))completion{
    
    //Check if city is alreay added
    NSManagedObjectContext *managedObjContext = [self managedObjectContext];
  
    NSFetchRequest *fetchReqCity = [[NSFetchRequest alloc] initWithEntityName:KEntity_Cities];
    [fetchReqCity setPredicate:[NSPredicate predicateWithFormat:@"placeid = %@",objCity.strPlaceID]];
    [fetchReqCity setReturnsObjectsAsFaults:NO];

    NSError *error;
    NSUInteger countResult  = [managedObjContext countForFetchRequest:fetchReqCity error:&error];
    
    if(countResult==0){
        //insert
        
        //Check if any one is home city
        
        NSManagedObjectContext *managedObjContext = [self managedObjectContext];
        
        NSFetchRequest *fetchReqCityisHome = [[NSFetchRequest alloc] initWithEntityName:KEntity_Cities];
        [fetchReqCityisHome setPredicate:[NSPredicate predicateWithFormat:@"ishome = %@",[NSNumber numberWithBool:YES]]];
        [fetchReqCityisHome setReturnsObjectsAsFaults:NO];
        
        NSError *error;
        NSUInteger countResultfetchReqCityisHome  = [managedObjContext countForFetchRequest:fetchReqCityisHome error:&error];
        
        BOOL isHome;
        if(countResultfetchReqCityisHome==0){
            //No home
            isHome = YES;
        }
        else{
            //Home already present
            isHome = NO;
        }
        
        Cities *managedObjCities = [NSEntityDescription insertNewObjectForEntityForName:KEntity_Cities inManagedObjectContext:managedObjContext];
        managedObjCities.cityname = objCity.strCityName;
        managedObjCities.counntryiso = objCity.strCountry;
        managedObjCities.latitude = objCity.strLatitude;
        managedObjCities.longitde = objCity.strLongitude;
        managedObjCities.placeid = objCity.strPlaceID;
        managedObjCities.state = objCity.strState;
        managedObjCities.timezone = objCity.strTimeZoneName;
        managedObjCities.ishome = [NSNumber numberWithBool:isHome];
        
        NSError *error1;
        if (![managedObjContext save:&error1]) {
            completion(0);
        }
        else{
            completion(1);
        }
    }
    else{
        //already city is added
        completion(1);
    }
}

+(void)fetchAllCitiesFromLocal:(void(^)(NSArray *arraySavedCities))responseData{
    NSManagedObjectContext *managedObjContext = [self managedObjectContext];
    
    NSFetchRequest *fetchReqCity = [[NSFetchRequest alloc] initWithEntityName:KEntity_Cities];
    [fetchReqCity setReturnsObjectsAsFaults:NO];
    
    NSError *error;
    
    NSArray *arrayRes = [managedObjContext executeFetchRequest:fetchReqCity error:&error];
    
    for (Cities *managedObjCity in arrayRes) {
        NSLog(@"City: %@",managedObjCity.cityname);
    }
}



@end
