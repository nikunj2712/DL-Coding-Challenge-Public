//
//  ConditionsModel.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cities+CoreDataProperties.h"

@interface ConditionsModel : NSObject
//                temp_f
//                weather
//                relative_humidity
//                wind_dir
//                wind_mph
//                pressure_in
//                feelslike_f
//                visibility_mi
//                icon_url
@property(strong,nonatomic)NSString *strIconURL;
@property(strong,nonatomic)NSString *strWindDir;
@property(strong,nonatomic)NSString *strweather;
@property(strong,nonatomic)NSNumber *numtemp_f;
@property(strong,nonatomic)NSNumber *numrelative_humidity;
@property(strong,nonatomic)NSNumber *numwind_mph;
@property(strong,nonatomic)NSNumber *numpressure_in;
@property(strong,nonatomic)NSNumber *numfeelslike_f;
@property(strong,nonatomic)NSNumber *numvisibility_mi;
@property(strong,nonatomic)Cities *managedObjCity;


@end
