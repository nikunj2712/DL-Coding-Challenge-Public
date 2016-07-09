//
//  AddCityViewController.m
//  iWeather
//
//  Created by Nikunj on 7/7/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import "AddCityViewController.h"
#import "WebserviceManager.h"
#import "NewCitiesModel.h"
#import "MBProgressHUD.h"



@interface AddCityViewController() <UITableViewDataSource,UITableViewDelegate>{
   __block NSArray *arrayNewCities;
   __block MBProgressHUD *hud;
    
}

@end

@implementation AddCityViewController

- (IBAction)buttonCancelPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)textFieldEditingBegan:(id)sender {
    NSLog(@"%@",self.textfieldCity.text);
    
    NSString *strTypedText = [self.textfieldCity.text stringByAddingPercentEscapesUsingEncoding:
                              NSUTF8StringEncoding];
    
    NSString* strWebServiceURL =[NSString stringWithFormat:@"%@&input=%@",KSERVER_GOOGLE_URL,strTypedText];
    
    if (strTypedText.length>1) {
        [WebserviceManager fetchCitiesFromURL:strWebServiceURL withResponse:^(NSArray *arrayCities) {
            arrayNewCities = [NSArray arrayWithArray:arrayCities];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableViewCities reloadData];
            });
        }];
    }
}

#pragma mark table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return arrayNewCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    UILabel *labelCityName = (UILabel*)[cell viewWithTag:1];
    NewCitiesModel *objCity = arrayNewCities[indexPath.row];
    labelCityName.text = objCity.strFullCityName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.label.text = NSLocalizedString(@"Fetching...", @"");
    
    NewCitiesModel *objCity = arrayNewCities[indexPath.row];
    
    [WebserviceManager saveCityUsingCityFullName:objCity withCompletion:^(BOOL status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if (status) {
                //success
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                //error todo
            }
        });
    }];
    
    //Add city to db after fetching lat, long and weather details
}


@end
