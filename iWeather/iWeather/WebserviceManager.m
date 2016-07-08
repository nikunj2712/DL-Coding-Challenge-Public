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
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error parsing cities" message:error.description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            
        }
        else{
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error fetching cities" message:error.description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
            //NSLog(@"no data fetchCitiesFromURL");
            return ;
        }
    }];
    [dataTask resume];
}

+(void)saveCityUsingCityFullName:(NewCitiesModel *)objCity withCompletion:(void(^)(BOOL status))status{
  
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
            NSString *strLat = [dictLocation objectForKey:@"lat"];
            NSString *strLng = [dictLocation objectForKey:@"lng"];
            
            NSString *strCoordinate = [NSString stringWithFormat:@"%@,%@",strLat,strLng];
            strCoordinate =  [strCoordinate stringByReplacingOccurrencesOfString:@" "  withString:@""];
            
            [WebserviceManager fetchTimeZoneandStateCodeForCoordinates:strCoordinate andUpdateNewCityObj:objCity withResponse:^(NewCitiesModel *objNewCity) {
                if (objNewCity) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       [CoredataManager insertNewCity:objNewCity withCompletion:^(BOOL isSaved) {
                           if (isSaved) {
                               status(YES);
                           }
                           else{
                               status(NO);
                           }
                       }];
                    });
                }else{
                    //error todo
                }
            }];
        }
        else{
            //NSLog(@"no data fetchCitiesFromURL");
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
            NSDictionary *dictLocation =  [dataJSON objectForKey:@"location"];
            if (dictLocation) {
                //
                objCity.strCountry = [dictLocation valueForKey:@"country_iso3166"];
                objCity.strState = [dictLocation valueForKey:@"state"];
                objCity.strTimeZoneName = [dictLocation valueForKey:@"tz_long"];
                responseData(objCity);
            }else{
                //No location found todo
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



@end
