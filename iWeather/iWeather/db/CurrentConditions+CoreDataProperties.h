//
//  CurrentConditions+CoreDataProperties.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CurrentConditions.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrentConditions (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *condition;
@property (nullable, nonatomic, retain) NSString *condition_icon_url;
@property (nullable, nonatomic, retain) NSNumber *feelslike;
@property (nullable, nonatomic, retain) NSNumber *humidity_percent;
@property (nullable, nonatomic, retain) NSNumber *pressure_in;
@property (nullable, nonatomic, retain) NSString *sunrise;
@property (nullable, nonatomic, retain) NSString *sunset;
@property (nullable, nonatomic, retain) NSNumber *tempin_f;
@property (nullable, nonatomic, retain) NSNumber *visibility_mile;
@property (nullable, nonatomic, retain) NSString *winddirection;
@property (nullable, nonatomic, retain) NSNumber *windspeed;
@property (nullable, nonatomic, retain) Cities *conditionBelongsToCity;

@end

NS_ASSUME_NONNULL_END
