//
//  HourlyViewController.m
//  iWeather
//
//  Created by Nikunj on 7/7/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import "HourlyViewController.h"

@interface HourlyViewController() <UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *arrayHourlyDetails;
}

@end

@implementation HourlyViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    NSString *min = @"60";
    NSString *max = @"100";
    
    
    arrayHourlyDetails = [NSMutableArray new];
    for (int i=1; i<=12; i++) {
        int randNum = rand() % ([max intValue] - [min intValue]) + [min intValue];

        NSMutableDictionary *dictDetails = [NSMutableDictionary new];
        NSString *strTime = [NSString stringWithFormat:@"%@AM",[NSNumber numberWithInt:i]];
        [dictDetails setValue:strTime forKey:@"time"];
        [dictDetails setValue:[NSString stringWithFormat:@"clear.gif"] forKey:@"iconurl"];
        [dictDetails setValue:[NSString stringWithFormat:@"%@°",[NSNumber numberWithInt:randNum]] forKey:@"temp"];
        [arrayHourlyDetails addObject:dictDetails];
    }
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrayHourlyDetails.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dictDetail = arrayHourlyDetails[indexPath.row];
    NSString *strImg = [dictDetail valueForKey:@"iconurl"];
    NSString *strTime = [dictDetail valueForKey:@"time"];
    NSString *strTemp = [dictDetail valueForKey:@"temp"];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:2];
    UILabel *labelTime = (UILabel*)[cell viewWithTag:1];
    UILabel *labelTemp = (UILabel*)[cell viewWithTag:3];
    imgView.image = [UIImage imageNamed:strImg];
    labelTemp.text = strTemp;
    labelTime.text = strTime;
    return cell;
}


@end
