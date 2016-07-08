//
//  CurrentConditions+CoreDataProperties.m
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CurrentConditions+CoreDataProperties.h"

@implementation CurrentConditions (CoreDataProperties)

@dynamic tempin_f;
@dynamic sunrise;
@dynamic sunset;
@dynamic windspeed;
@dynamic winddirection;
@dynamic feelslike;
@dynamic pressure_in;
@dynamic humidity_percent;
@dynamic visibility_mile;
@dynamic condition;
@dynamic condition_icon_url;
@dynamic conditionBelongsToCity;

@end
