//
//  NewCitiesModel.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewCitiesModel : NSObject
@property(strong,nonatomic)NSString *strCityName;
@property(strong,nonatomic)NSString *strFullCityName;
@property(strong,nonatomic)NSString *strPlaceID;
@property(strong,nonatomic)NSString *strCountry;
@property(strong,nonatomic)NSString *strState;
@property(strong,nonatomic)NSString *strLatitude;
@property(strong,nonatomic)NSString *strLongitude;
@property(strong,nonatomic)NSString *strTimeZoneName;
@end
