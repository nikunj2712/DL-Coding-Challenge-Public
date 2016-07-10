//
//  DetailViewController.m
//  iWeather
//
//  Created by Nikunj on 7/7/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController() <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *arrayForecastDetails;
    NSMutableArray *arrayForecast3Details;
}

@end

@implementation DetailViewController



-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *minForMin = @"55";
    NSString *maxForMin = @"65";
    
    NSString *minForMax = @"66";
    NSString *maxForMax = @"100";
    
    arrayForecastDetails = [NSMutableArray new];
    for (int i=1; i<=10; i++) {
        int randNumMin = rand() % ([maxForMin intValue] - [minForMin intValue]) + [minForMin intValue];
        
        int randNumMax = rand() % ([maxForMax intValue] - [minForMax intValue]) + [minForMax intValue];
        
        NSMutableDictionary *dictDetails = [NSMutableDictionary new];
        NSString *strTime = [NSString stringWithFormat:@"Day %@",[NSNumber numberWithInt:i]];
        [dictDetails setValue:strTime forKey:@"day"];
        [dictDetails setValue:[NSString stringWithFormat:@"clear.gif"] forKey:@"iconurl"];
        [dictDetails setValue:[NSString stringWithFormat:@"%@°",[NSNumber numberWithInt:randNumMin]] forKey:@"tempmin"];
        [dictDetails setValue:[NSString stringWithFormat:@"%@°",[NSNumber numberWithInt:randNumMax]] forKey:@"tempmax"];
        [arrayForecastDetails addObject:dictDetails];
    }
    
    arrayForecast3Details = [NSMutableArray new];
    for (int i=1; i<=3; i++) {
        int randNumMin = rand() % ([maxForMin intValue] - [minForMin intValue]) + [minForMin intValue];
        
        int randNumMax = rand() % ([maxForMax intValue] - [minForMax intValue]) + [minForMax intValue];
        
        NSMutableDictionary *dictDetails = [NSMutableDictionary new];
        NSString *strTime = [NSString stringWithFormat:@"Day %@",[NSNumber numberWithInt:i]];
        [dictDetails setValue:strTime forKey:@"day"];
        [dictDetails setValue:[NSString stringWithFormat:@"clear.gif"] forKey:@"iconurl"];
        [dictDetails setValue:[NSString stringWithFormat:@"%@°",[NSNumber numberWithInt:randNumMin]] forKey:@"tempmin"];
        [dictDetails setValue:[NSString stringWithFormat:@"%@°",[NSNumber numberWithInt:randNumMax]] forKey:@"tempmax"];
        [arrayForecast3Details addObject:dictDetails];
    }
    self.tableViewDayFoarecast.scrollEnabled=FALSE;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.labelCityName.text = self.selectedCity.strCityName;
    self.labelCondition.text = self.selectedCity.strWeather;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.segmentDaySelection setSelectedSegmentIndex:0];
    [self segmentDayValueChanged:self.segmentDaySelection];
    [self animateWindMill];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segmentDaySelection.selectedSegmentIndex) {
        //10
            return arrayForecastDetails.count;
    }
    else{
        //3day
            return arrayForecast3Details.count;
    }
    return arrayForecastDetails.count;
}

-(void)animateWindMill{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 5.0f;
    animation.repeatCount = INFINITY;
    [self.imgFan.layer addAnimation:animation forKey:@"SpinAnimation"];
    
    [self.imgCloud setNeedsUpdateConstraints];
    [self.viewParentCloud setNeedsUpdateConstraints];

//    [UIView animateWithDuration:2.0f animations:^{
//
//           } completion:^(BOOL finished) {
//
//    }];
    
    [UIView animateWithDuration:15.0 delay:0 options: UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
        self.constCloudXPos.constant = 200;
        self.imgCloud.alpha = 0.2;
        self.imgWind.alpha = 0.2;
        [self.imgCloud layoutIfNeeded];
        [self.viewParentCloud layoutIfNeeded];

    } completion:^(BOOL finished) {
        self.constCloudXPos.constant = -70;
        self.imgCloud.alpha = 1;
        self.imgWind.alpha = 1;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary *dictDetail = arrayForecastDetails[indexPath.row];
    
    if (self.segmentDaySelection.selectedSegmentIndex) {
        //10
        dictDetail = arrayForecastDetails[indexPath.row];    }
    else{
        //3day
        dictDetail = arrayForecast3Details[indexPath.row];
    }
    
    NSString *strImg = [dictDetail valueForKey:@"iconurl"];
    NSString *strday = [dictDetail valueForKey:@"day"];
    NSString *strtempmin = [dictDetail valueForKey:@"tempmin"];
    NSString *strtempmax = [dictDetail valueForKey:@"tempmax"];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:4];
    UILabel *labelDay = (UILabel*)[cell viewWithTag:1];
    UILabel *labelTempMax = (UILabel*)[cell viewWithTag:2];
    UILabel *labelTempMin = (UILabel*)[cell viewWithTag:3];
    imgView.image = [UIImage imageNamed:strImg];
    labelDay.text = strday;
    labelTempMax.text = strtempmax;
    labelTempMin.text = strtempmin;
    return cell;

}

- (IBAction)segmentDayValueChanged:(id)sender {
    
    [self.tableViewDayFoarecast reloadData];
    
    UISegmentedControl *seg = (UISegmentedControl*)sender;
    if (seg.selectedSegmentIndex) {
        //10 day
        
        [self.tableViewDayFoarecast setNeedsUpdateConstraints];
        [self.contentViewMain setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.5 animations:^{
            self.constTableDayForecastHeight.constant = (arrayForecastDetails.count*55);
            [self.tableViewDayFoarecast layoutIfNeeded];
            [self.contentViewMain layoutIfNeeded];
            [self.view layoutIfNeeded];
        }];
    }
    else{
        //3day
        [self.tableViewDayFoarecast setNeedsUpdateConstraints];
        [self.contentViewMain setNeedsUpdateConstraints];
        [UIView animateWithDuration:0.5 animations:^{
            self.constTableDayForecastHeight.constant = self.constTableDayForecastHeight.constant = (arrayForecast3Details.count*55);
            [self.tableViewDayFoarecast layoutIfNeeded];
            [self.contentViewMain layoutIfNeeded];
            [self.view layoutIfNeeded];
        }];
    }
    
}
@end
