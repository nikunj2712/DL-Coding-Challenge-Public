//
//  CoredataManager.m
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

@import CoreData;
#import "CoredataManager.h"
#import "ListCityDetailsModel.h"


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

+(void)insertNewCity:(NewCitiesModel *)objCity withCompletion:(void(^)(BOOL isSaved, Cities *managedObjCity))completion{
    
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
            completion(0,nil);
        }
        else{
            completion(1,managedObjCities);
        }
    }
    else{
        //already city is added
        completion(1,nil);
    }
}

+(void)fetchAllCitiesFromLocal:(void(^)(NSArray *arraySavedCities))responseData{
    NSManagedObjectContext *managedObjContext = [self managedObjectContext];
    
    NSFetchRequest *fetchReqCity = [[NSFetchRequest alloc] initWithEntityName:KEntity_Cities];
    [fetchReqCity setReturnsObjectsAsFaults:NO];
    
    NSError *error;
    
    NSArray *arrayRes = [managedObjContext executeFetchRequest:fetchReqCity error:&error];
    
//    *strWeather;
//    @property(nonatomic,strong) NSNumber *numTempF;
//    @property(nonatomic,strong) NSString *strTimeZone;
//    @property(nonatomic) BOOL *isHome;
//
    
    NSMutableArray *arrayCityList = [NSMutableArray new];
    for (Cities *managedObjCities in arrayRes) {
        ListCityDetailsModel *modelCityListDetails = [ListCityDetailsModel new];
        modelCityListDetails.strCityName = managedObjCities.cityname;
        modelCityListDetails.strTimeZone = managedObjCities.timezone;
        NSFetchRequest *fetchReqConditions = [[NSFetchRequest alloc] initWithEntityName:KEntity_Conditions];
        [fetchReqConditions setPredicate:[NSPredicate predicateWithFormat:@"conditionBelongsToCity == %@",managedObjCities.objectID]];
        [fetchReqConditions setReturnsObjectsAsFaults:NO];
        
        NSArray *arrayResConditions = [managedObjContext executeFetchRequest:fetchReqConditions error:nil];
        if (arrayResConditions.count>0) {
            CurrentConditions *managedObjConditions = [arrayResConditions firstObject];
            modelCityListDetails.condition_icon_url = managedObjConditions.condition_icon_url;
            modelCityListDetails.numTempF = managedObjConditions.tempin_f;
            modelCityListDetails.strWeather = managedObjConditions.condition;
            [arrayCityList addObject:modelCityListDetails];
        }
    }
    
    responseData(arrayCityList);
    
//    for (Cities *managedObjCity in arrayRes) {
//        NSLog(@"City: %@",managedObjCity.cityname);
//    }
}

+(void)insertCurrentConditionsForCity:(Cities *)managedObjCity andData:(ConditionsModel *)modelConditions withCompletion:(void(^)(BOOL isSaved))completion{
    NSManagedObjectContext *managedObjContext = [self managedObjectContext];

//    NSString *condition;
//    NSString *condition_icon_url;
//    NSNumber *feelslike;
//    NSNumber *humidity_percent;
//    NSNumber *pressure_in;
//    NSString *sunrise;
//    NSString *sunset;
//    NSNumber *tempin_f;
//    NSNumber *visibility_mile;
//    NSString *winddirection;
//    NSNumber *windspeed;
//    Cities *conditionBelongsToCity;
    
//    NSString *strIconURL;
//    NSString *strWindDir;
//    NSString *strweather;
//    NSNumber *numtemp_f;
//    NSNumber *numrelative_humidity;
//    NSNumber *numwind_mph;
//    NSNumber *numpressure_in;
//    NSNumber *numfeelslike_f;
//    NSNumber *numvisibility_mi;
//    Cities *managedObjCity;
    
    NSFetchRequest *fetchReqCondition = [[NSFetchRequest alloc] initWithEntityName:KEntity_Conditions];
    [fetchReqCondition setReturnsObjectsAsFaults:NO];
    [fetchReqCondition setPredicate:[NSPredicate predicateWithFormat:@"conditionBelongsToCity == %@",managedObjCity.objectID]];
    NSError *error;
    NSArray *arrayRes = [managedObjContext executeFetchRequest:fetchReqCondition error:&error];
    
    if (arrayRes.count>0) {
        //Already exists
        CurrentConditions *managedObjConditions = [arrayRes firstObject];
        managedObjConditions.condition = modelConditions.strweather ;
        managedObjConditions.condition_icon_url = modelConditions.strIconURL ;
        managedObjConditions.feelslike = modelConditions.numfeelslike_f ;
        managedObjConditions.humidity_percent = modelConditions.numrelative_humidity ;
        managedObjConditions.pressure_in = modelConditions.numpressure_in ;
        managedObjConditions.tempin_f = modelConditions.numtemp_f ;
        managedObjConditions.visibility_mile = modelConditions.numvisibility_mi ;
        managedObjConditions.winddirection = modelConditions.strWindDir ;
        managedObjConditions.windspeed = modelConditions.numwind_mph ;
    }
    else{
        //insert new
     CurrentConditions *managedObjConditions = [NSEntityDescription insertNewObjectForEntityForName:KEntity_Conditions inManagedObjectContext:managedObjContext];
        managedObjConditions.condition = modelConditions.strweather ;
        managedObjConditions.condition_icon_url = modelConditions.strIconURL ;
        managedObjConditions.feelslike = modelConditions.numfeelslike_f ;
        managedObjConditions.humidity_percent = modelConditions.numrelative_humidity ;
        managedObjConditions.pressure_in = modelConditions.numpressure_in ;
        managedObjConditions.tempin_f = modelConditions.numtemp_f ;
        managedObjConditions.visibility_mile = modelConditions.numvisibility_mi ;
        managedObjConditions.winddirection = modelConditions.strWindDir ;
        managedObjConditions.windspeed = modelConditions.numwind_mph ;
        managedObjConditions.conditionBelongsToCity = managedObjCity;
    }
    
    NSError *error1;
    if (![managedObjContext save:&error1]) {
        completion(0);
    }
    else{
        completion(1);
    }

}

@end
