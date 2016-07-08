//
//  CoredataManager.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

//This singleton class handles all core data stuff for storing data persistently

#import <Foundation/Foundation.h>

@interface CoredataManager : NSObject

+(CoredataManager *)sharedCoreData;

@end
