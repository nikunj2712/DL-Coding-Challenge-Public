//
//  Cities+CoreDataProperties.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cities.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cities (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *cityname;
@property (nullable, nonatomic, retain) NSString *counntryiso;
@property (nullable, nonatomic, retain) NSNumber *ishome;
@property (nullable, nonatomic, retain) NSString *latitude;
@property (nullable, nonatomic, retain) NSString *longitde;
@property (nullable, nonatomic, retain) NSString *placeid;
@property (nullable, nonatomic, retain) NSString *state;
@property (nullable, nonatomic, retain) NSString *timezone;
@property (nullable, nonatomic, retain) CurrentConditions *hasCondition;
@property (nullable, nonatomic, retain) NSSet<Forecasts *> *hasForecast;
@property (nullable, nonatomic, retain) NSSet<HourlyForecasts *> *hasHourlyForecast;

@end

@interface Cities (CoreDataGeneratedAccessors)

- (void)addHasForecastObject:(Forecasts *)value;
- (void)removeHasForecastObject:(Forecasts *)value;
- (void)addHasForecast:(NSSet<Forecasts *> *)values;
- (void)removeHasForecast:(NSSet<Forecasts *> *)values;

- (void)addHasHourlyForecastObject:(HourlyForecasts *)value;
- (void)removeHasHourlyForecastObject:(HourlyForecasts *)value;
- (void)addHasHourlyForecast:(NSSet<HourlyForecasts *> *)values;
- (void)removeHasHourlyForecast:(NSSet<HourlyForecasts *> *)values;

@end

NS_ASSUME_NONNULL_END
