//
//  WebserviceManager.m
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import "WebserviceManager.h"
#import "NewCitiesModel.h"
#import <AFNetworking/AFNetworking.h>
#import "CoredataManager.h"
#import "ConditionsModel.h"

@implementation WebserviceManager

+(WebserviceManager *)sharedWebservices{
    static dispatch_once_t oncePred=0;
    static WebserviceManager *_sharedObj = nil;
    dispatch_once(&oncePred, ^{
        _sharedObj = [[WebserviceManager alloc]init];
    });
    return _sharedObj;
}


#pragma mark Add new city
+(void)fetchCitiesFromURL:(NSString *)urlString withResponse:(void(^)(NSArray *arrayCities))responseReceived{
    //From Google maps API
    NSURL *URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    __block NSDictionary *dataJSON;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (responseObject) {
            dataJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
            if (!error) {
                NSLog(@"dataJSON = %@",[dataJSON description]);
                
                NSArray *arrayPredictions = [dataJSON objectForKey:@"predictions"];
                NSMutableArray *arrayNewCities = [NSMutableArray new];
                for (int i=0; i<arrayPredictions.count; i++) {
                    NewCitiesModel *objCity = [[NewCitiesModel alloc] init];
                    NSDictionary *dictCurrentPrediction = arrayPredictions[i];
                    NSString *strCityFullName = [dictCurrentPrediction valueForKey:@"description"];
                    
                    NSString *strPalceID = [dictCurrentPrediction valueForKey:@"place_id"];
                    NSArray *arrayTerms=[dictCurrentPrediction objectForKey:@"terms"];
                    
                    NSString *strState;
                    NSString *strCity;
                    NSString *strCountry;
                    
                    if (arrayTerms.count==3) {
                        strCity = [arrayTerms[0] valueForKey:@"value"];
                        strState = [arrayTerms[1] valueForKey:@"value"];
                        strCountry = [arrayTerms[2] valueForKey:@"value"];
                        NSLog(@"strCityFullName = %@",strCityFullName);
                    }
                    else{
                        strCity = [[arrayTerms firstObject] valueForKey:@"value"];
                        strCountry = [[arrayTerms lastObject] valueForKey:@"value"];
                    }
                    
                    objCity.strCityName = strCity;
                    objCity.strCountry = strCountry;
                    objCity.strFullCityName = strCityFullName;
                    objCity.strPlaceID = strPalceID;
                    [arrayNewCities addObject:objCity];
                }
                responseReceived(arrayNewCities);
            }
            else{
                if (error) {
                    //todo
                }
            }
        }
        else{
            if (error) {
                //todo
            }
            //NSLog(@"no data fetchCitiesFromURL");
            return ;
        }
    }];
    [dataTask resume];
}

+(void)saveCityUsingCityFullName:(NewCitiesModel *)objCity withCompletion:(void(^)(BOOL status))status1{
    
    NSString *urlString = [NSString stringWithFormat:@"%@&address=%@",KSERVER_GOOGLEURL_LAT_LONG,objCity.strFullCityName];
    
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:
                                       NSUTF8StringEncoding]];
    // NSLog(@"URL %@",URL);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    __block NSDictionary *dataJSON;
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (responseObject) {
            dataJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
            NSLog(@"Error: %@\ndataJSON = %@",error,[dataJSON description]);
            
            NSDictionary *dictResult = [dataJSON objectForKey:@"results"][0];
            NSDictionary *dictGeometry = [dictResult objectForKey:@"geometry"];
            NSDictionary *dictLocation = [dictGeometry objectForKey:@"location"];
            //
            NSString *strLat = [[dictLocation objectForKey:@"lat"] stringValue];
            NSString *strLng = [[dictLocation objectForKey:@"lng"] stringValue];
            
            objCity.strLatitude = strLat;
            objCity.strLongitude = strLng;
            
            NSString *strCoordinate = [NSString stringWithFormat:@"%@,%@",strLat,strLng];
            strCoordinate =  [strCoordinate stringByReplacingOccurrencesOfString:@" "  withString:@""];
            
            [WebserviceManager fetchTimeZoneandStateCodeForCoordinates:strCoordinate andUpdateNewCityObj:objCity withResponse:^(NewCitiesModel *objNewCity) {
                if (objNewCity) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [CoredataManager insertNewCity:objNewCity withCompletion:^(BOOL isSaved, Cities *managedObjCity) {
                            if (isSaved) {
                                
                                NSString *strShortCode;
                                //Fetch Current conditions
                                if (objNewCity.strState.length==0) {
                                    strShortCode = objNewCity.strCountry;
                                }else{
                                    strShortCode = objNewCity.strState;
                                }
                                NSString *stringQuery = [NSString stringWithFormat:@"%@/%@",strShortCode,objNewCity.strCityName];
                                
                                [WebserviceManager saveCityConditionsForQuery:stringQuery andCity:managedObjCity withCompletion:^(BOOL status) {
                                    if (status) {
                                        status1(YES);
                                    }
                                }];
                            }
                            else{
                                status1(NO);
                            }
                        }];
                    });
                }else{
                    //error todo
                     status1(NO);
                }
            }];
        }
        else{
            //NSLog(@"no data fetchCitiesFromURL");
             status1(NO);
            return ;
        }
    }];
    [dataTask resume];
}


#pragma mark Weather UN Geo
+(void)fetchTimeZoneandStateCodeForCoordinates:(NSString *)strCoordinates andUpdateNewCityObj:(NewCitiesModel *)objCity withResponse:(void(^)(NewCitiesModel *objNewCity))responseData{
    
    NSString *urlString = [NSString stringWithFormat:@"%@geolookup/q/%@.json",KSERVER_WEATHERUNDERGROUND_URL,strCoordinates];
    
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:
                                       NSUTF8StringEncoding]];
    // NSLog(@"URL %@",URL);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    __block NSDictionary *dataJSON;
    
    //    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response,NSError *error) {
        
        if (data) {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Error: %@\ndataJSON = %@",error,[dataJSON description]);
            if(!dataJSON){
                responseData(nil);
            }
            NSDictionary *dictError =  [dataJSON objectForKey:@"error"];
            
            if (dictError) {
                NSString *strErro = [dictError valueForKey:@"description"];
                //todo
                responseData(nil);
            }
            NSDictionary *dictLocation =  [dataJSON objectForKey:@"location"];
            if (dictLocation) {
                //
                objCity.strCountry = [dictLocation valueForKey:@"country_iso3166"];
                objCity.strState = [dictLocation valueForKey:@"state"];
                objCity.strTimeZoneName = [dictLocation valueForKey:@"tz_long"];
                responseData(objCity);
            }else{
                //No location found todo
                //todo
                responseData(nil);
            }
        }
        else{
            //NSLog(@"no data fetchCitiesFromURL");
            //            todo
            
            responseData(nil);
            return ;
        }
    }];
    [dataTask resume];
}

+(void)saveCityConditionsForQuery:(NSString *)stringQuery andCity:(Cities *)managedObjCity withCompletion:(void(^)(BOOL status))status{
    NSString *urlString = [NSString stringWithFormat:@"%@conditions/q/%@.json",KSERVER_WEATHERUNDERGROUND_URL,stringQuery];
    
    NSURL *URL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:
                                       NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    __block NSDictionary *dataJSON;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response,NSError *error) {
        
        if (data) {
            dataJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Error: %@\nsaveCityConditionsForQuery dataJSON = %@",error,[dataJSON description]);
            
            if(!dataJSON){
                status(NO);
            }
            NSDictionary *dictError =  [dataJSON objectForKey:@"error"];
            
            if (dictError) {
                NSString *strErro = [dictError valueForKey:@"description"];
                //todo
                status(NO);
            }else{
                //save fetched data
//                temp_f
//                weather
//                relative_humidity
//                wind_dir
//                wind_mph
//                pressure_in
//                feelslike_f
//                visibility_mi
//                icon_url
                
                NSDictionary *dictCurrentObs =  [dataJSON objectForKey:@"current_observation"];
                
                NSString *strWeather = [dictCurrentObs valueForKey:@"weather"];
                NSString *stricon_url = [dictCurrentObs valueForKey:@"icon_url"];
                NSString *strWindDir = [dictCurrentObs valueForKey:@"wind_dir"];

                NSNumber *numtemp_f = [NSNumber numberWithFloat:[[dictCurrentObs valueForKey:@"temp_f"] floatValue]];
                NSNumber *numrelative_humidity = [NSNumber numberWithFloat:[[dictCurrentObs valueForKey:@"relative_humidity"] floatValue]];
                NSNumber *numwind_mph = [NSNumber numberWithFloat:[[dictCurrentObs valueForKey:@"wind_mph"] floatValue]];
                NSNumber *numpressure_in = [NSNumber numberWithFloat:[[dictCurrentObs valueForKey:@"pressure_in"] floatValue]];
                NSNumber *numvisibility_mi = [NSNumber numberWithFloat:[[dictCurrentObs valueForKey:@"visibility_mi"] floatValue]];
                NSNumber *numfeelslike_f = [NSNumber numberWithFloat:[[dictCurrentObs valueForKey:@"feelslike_f"] floatValue]];
               
                
                ConditionsModel *modelCondition = [ConditionsModel new];
                modelCondition.strIconURL = stricon_url;
                modelCondition.strWindDir = strWindDir;
                modelCondition.strweather = strWeather;
                modelCondition.numtemp_f = numtemp_f;
                modelCondition.numrelative_humidity = numrelative_humidity;
                modelCondition.numwind_mph = numwind_mph;
                modelCondition.numpressure_in = numpressure_in;
                modelCondition.numfeelslike_f = numfeelslike_f;
                modelCondition.numvisibility_mi = numvisibility_mi;
                modelCondition.managedObjCity = managedObjCity;
                
                [CoredataManager insertCurrentConditionsForCity:managedObjCity andData:modelCondition withCompletion:^(BOOL isSaved) {
                    if (isSaved) {
                        status(YES);
                        NSLog(@" insertCurrentConditionsForCity success");
                    }
                }];
            }
            
            //Store in core data
            
            status(YES);
        }
        else{
            //NSLog(@"no data fetchCitiesFromURL");
            //            todo
            
            status(NO);
            return ;
        }
    }];
    [dataTask resume];
    
}


@end
