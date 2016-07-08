//
//  AddCityViewController.h
//  iWeather
//
//  Created by Nikunj on 7/7/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

//This VC lets user add new cities, the view controller list suggestions of cities as entered.

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface AddCityViewController : UIViewController
@property(nonatomic,weak)HomeViewController *vcHome;
- (IBAction)buttonCancelPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *textfieldCity;
- (IBAction)textFieldEditingBegan:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableViewCities;


@end
