//
//  MenuTableViewController.h
//  iWeather
//
//  Created by Nikunj on 7/9/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

@protocol MenuTableViewControllerDelegate <NSObject>

@optional
-(void)tempUnitChanged;
-(void)openSourcePressed;
-(void)currentLocationPressed;
-(void)addNewCityPressed;

@end
#import <UIKit/UIKit.h>

@interface MenuTableViewController : UITableViewController
- (IBAction)tempUnitChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentTempUnit;
@property (weak, nonatomic) id <MenuTableViewControllerDelegate> delegateMenu;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellCurrentLoc;
@property (strong, nonatomic) IBOutlet UITableView *tableViewMain;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellAddCity;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellTempUnit;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellDistanceUnit;
@property (weak, nonatomic) IBOutlet UITableViewCell *cellOpenSource;
@end
