//
//  Forecasts+CoreDataProperties.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Forecasts.h"

NS_ASSUME_NONNULL_BEGIN

@interface Forecasts (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *order;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *condition_icon;
@property (nullable, nonatomic, retain) NSNumber *max;
@property (nullable, nonatomic, retain) NSNumber *min;
@property (nullable, nonatomic, retain) NSNumber *humidity_percent;
@property (nullable, nonatomic, retain) NSString *condition;
@property (nullable, nonatomic, retain) Cities *forecastBelongsToCity;

@end

NS_ASSUME_NONNULL_END
