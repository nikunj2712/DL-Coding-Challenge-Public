//
//  Forecasts+CoreDataProperties.m
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Forecasts+CoreDataProperties.h"

@implementation Forecasts (CoreDataProperties)

@dynamic condition;
@dynamic condition_icon;
@dynamic date;
@dynamic humidity_percent;
@dynamic max;
@dynamic min;
@dynamic order;
@dynamic forecastBelongsToCity;

@end
