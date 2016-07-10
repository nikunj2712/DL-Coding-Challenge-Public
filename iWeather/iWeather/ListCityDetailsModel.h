//
//  ListCityDetailsModel.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cities+CoreDataProperties.h"

@interface ListCityDetailsModel : NSObject

@property(nonatomic,strong) NSString *strCityName;
@property(nonatomic,strong) NSString *strState;
@property(nonatomic,strong) NSString *strCountry;
@property(nonatomic,strong) NSString *strWeather;
@property(nonatomic,strong) NSNumber *numTempF;
@property(nonatomic,strong) NSString *strTimeZone;
@property(nonatomic,strong) NSString *strPlaceID;
@property(nonatomic,strong) NSString *condition_icon_url;
@property(nonatomic,strong) Cities *managedObjCity;
@property(nonatomic) BOOL *isHome;

@end
