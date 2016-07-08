//
//  ListFavoriteCitiesViewController.m
//  iWeather
//
//  Created by Nikunj on 7/8/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CoredataManager.h"
#import "CityTableViewCell.h"
#import "Cities.h"

@interface MasterViewController() <HomeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    DetailViewController *vcDetail;
    __block NSArray *arrayCities;
}
@end

@implementation MasterViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.viewMain.layer.cornerRadius = 20.0;
    self.viewMain.layer.masksToBounds = YES;
    self.vcHome.delegateHomeVC = self;
    
    UINib *nibCell = [UINib nibWithNibName:@"CellCities" bundle:nil];
    [self.tableViewCities registerNib:nibCell forCellReuseIdentifier:@"cell"];
    
    [CoredataManager fetchAllCitiesFromLocal:^(NSArray *arraySavedCities) {
        arrayCities = [NSArray arrayWithArray:arraySavedCities];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableViewCities reloadData];
        });
    }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toDetailVC"]) {
        vcDetail = segue.destinationViewController;
    }
}

#pragma mark HomeVC Delegate
-(void)menuPressed{
    self.vcHome.isBackEnabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
    [self.viewMain setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.constViewMainYpos.constant=0;
        [self.viewMain layoutIfNeeded]; // 3
    } completion:^(BOOL finished) {
    }];
}

#pragma mark Table View delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CityTableViewCell *cell = [self.tableViewCities dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Cities *managedObjCity = arrayCities[indexPath.row];
    cell.labelCityName.text = managedObjCity.cityname;
    return cell;
}

- (IBAction)buttonPressed:(id)sender {
    self.vcHome.isBackEnabled = YES;
    [self.viewMain setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.constViewMainYpos.constant=self.viewMain.frame.size.height;
        [self.viewMain layoutIfNeeded]; // 3
    } completion:^(BOOL finished) {
        
        //push Detail VC
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"toDetailVC" sender:self];
        });
    }];
    
    
}
@end
