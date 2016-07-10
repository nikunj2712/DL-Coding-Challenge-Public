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
#import "ListCityDetailsModel.h"
#import "WebserviceManager.h"


@interface MasterViewController() <HomeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    DetailViewController *vcDetail;
    __block NSMutableArray *arrayCities;
    ListCityDetailsModel *selectedCity;

    BOOL isUnitFarenheit;
    
}
@property (nonatomic,strong) UIRefreshControl *refreshControl;
@end

@implementation MasterViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.viewMain.layer.cornerRadius = 20.0;
    self.viewMain.layer.masksToBounds = YES;
    self.vcHome.delegateHomeVC = self;
    
    UINib *nibCell = [UINib nibWithNibName:@"CellCities" bundle:nil];
    [self.tableViewCities registerNib:nibCell forCellReuseIdentifier:@"cell"];
    [self fetchLatestData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(fetchLatestData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableViewCities addSubview:self.refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchLatestData)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
}

-(void)refreshData{
    isUnitFarenheit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tempunit"] boolValue];
    [CoredataManager fetchAllCitiesFromLocal:^(NSArray *arraySavedCities) {
        arrayCities = [[NSArray arrayWithArray:arraySavedCities] mutableCopy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableViewCities reloadData];
        });
    }];
}

-(void)fetchLatestData{
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    for (ListCityDetailsModel *objCity in arrayCities) {
        
        NSString *strShortCode;
        //Fetch Current conditions
        if (objCity.strState.length==0) {
            strShortCode = objCity.strCountry;
        }else{
            strShortCode = objCity.strState;
        }
        NSString *stringQuery = [NSString stringWithFormat:@"%@/%@",strShortCode,objCity.strCityName];
        
        [WebserviceManager saveCityConditionsForQuery:stringQuery andCity:objCity.managedObjCity withCompletion:^(BOOL status) {
            dispatch_semaphore_signal(sem);
        }];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    }
    [self refreshData];
    [self.refreshControl endRefreshing];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toDetailVC"]) {
        vcDetail = segue.destinationViewController;
        vcDetail.selectedCity = selectedCity;
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
    ListCityDetailsModel *modelCity = arrayCities[indexPath.row];
    cell.labelCityName.text = modelCity.strCityName;
    
    NSString *strTemp;
    
    if (isUnitFarenheit) {
        //f
        strTemp = [NSString stringWithFormat:@"%@",modelCity.numTempF];
    }else{
        //c
        strTemp =  [NSString stringWithFormat:@"%.0f",([modelCity.numTempF floatValue] - 32) / 1.8] ;
    }
    
    cell.labelTemp.text =  strTemp;
    cell.labelCondition.text = modelCity.strWeather;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tag = indexPath.row;
    if (!cell.imageviewCondition.image) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^(void) {
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:modelCity.condition_icon_url]];
                                 
                                 UIImage* image = [[UIImage alloc] initWithData:imageData];
                                 if (image) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         if (cell.tag == indexPath.row) {
                                             cell.imageviewCondition.image = image;
                                             [cell setNeedsLayout];
                                         }
                                     });
                                 }
                                 });
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ListCityDetailsModel *modelCity = arrayCities[indexPath.row];
    selectedCity = modelCity;

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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        ListCityDetailsModel *objCity = arrayCities[indexPath.row];
        [CoredataManager deleteCityWithPlaceID:objCity.strPlaceID withCompletion:^(BOOL isSucess) {
            if (isSucess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [arrayCities removeObjectAtIndex:indexPath.row];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                    [self refreshData];
                });
            }
        }];
    }
}

- (IBAction)buttonPressed:(id)sender {
    
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
