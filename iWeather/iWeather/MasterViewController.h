//
//  ListFavoriteCitiesViewController.h
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//


//As the name of this VC suggests, this is the main VC to display all weather related details in list and even the details. User can move back & forth to view as list or detailed.


#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface MasterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constViewMainYpos;
- (IBAction)buttonPressed:(id)sender;
@property(weak,nonatomic) HomeViewController *vcHome;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCities;
-(void)refreshData;
@end
