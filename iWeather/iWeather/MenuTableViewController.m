//
//  MenuTableViewController.m
//  iWeather
//
//  Created by Nikunj on 7/9/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import "MenuTableViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.cellCurrentLoc setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.cellAddCity setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.cellTempUnit setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.cellDistanceUnit setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.cellOpenSource setSelectionStyle:UITableViewCellSelectionStyleNone];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"tempunit"]) {
        if ([self.segmentTempUnit selectedSegmentIndex]) {
            //1 faren
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"tempunit"];
        }
        else{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"tempunit"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        BOOL isfaren = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempunit"] boolValue];
        if (isfaren) {
            [self.segmentTempUnit setSelectedSegmentIndex:1];
        }
        else{
            [self.segmentTempUnit setSelectedSegmentIndex:0];
        }
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *theCellClicked = [self.tableViewMain cellForRowAtIndexPath:indexPath];
    if (theCellClicked == self.cellCurrentLoc) {
    }
    if (theCellClicked == self.cellAddCity) {
    }
    if (theCellClicked == self.cellOpenSource) {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tempUnitChanged:(id)sender {
    if ([self.segmentTempUnit selectedSegmentIndex]) {
        //1 faren
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"tempunit"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"tempunit"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if ([self.delegateMenu respondsToSelector:@selector(tempUnitChanged)]) {
        [self.delegateMenu tempUnitChanged];
    }
}
@end
