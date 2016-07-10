//
//  DetailViewController.h
//  iWeather
//
//  Created by Nikunj on 7/7/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListCityDetailsModel.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *labelCityName;
@property (weak, nonatomic) IBOutlet UILabel *labelCondition;
@property (nonatomic,strong) ListCityDetailsModel *selectedCity;
@property (weak, nonatomic) IBOutlet UITableView *tableViewDayFoarecast;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentDaySelection;
- (IBAction)segmentDayValueChanged:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constTableDayForecastHeight;
@property (weak, nonatomic) IBOutlet UIView *contentViewMain;
@property (weak, nonatomic) IBOutlet UIImageView *imgCloud;
@property (weak, nonatomic) IBOutlet UIImageView *imgWind;
@property (weak, nonatomic) IBOutlet UIImageView *imgFan;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constCloudXPos;
@property (weak, nonatomic) IBOutlet UIView *viewParentCloud;

@end
