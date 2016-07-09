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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.labelCityName.text = self.selectedCity.strCityName;
    self.labelCondition.text = self.selectedCity.strWeather;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayForecastDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   
    NSDictionary *dictDetail = arrayForecastDetails[indexPath.row];
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

@end
