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
            //NSLog(@"no data fetchCitiesFromURL");
            return ;
        }
    }];
    [dataTask resume];
}

+(void)fetchLatitudeLongitudeFromCityFullName:(NSString *)strCityFullName withResponse:(void(^)(NSString *strTZId))responseData{
  

}


@end
