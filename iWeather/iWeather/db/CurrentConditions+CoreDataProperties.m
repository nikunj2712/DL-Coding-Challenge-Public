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

@dynamic condition;
@dynamic condition_icon_url;
@dynamic feelslike;
@dynamic humidity_percent;
@dynamic pressure_in;
@dynamic sunrise;
@dynamic sunset;
@dynamic tempin_f;
@dynamic visibility_mile;
@dynamic winddirection;
@dynamic windspeed;
@dynamic conditionBelongsToCity;

@end
