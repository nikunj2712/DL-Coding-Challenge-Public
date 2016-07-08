//
//  ViewController.m
//  iWeather
//
//  Created by Nikunj on 7/7/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

@import QuartzCore;
#import "HomeViewController.h"
#import "MasterViewController.h"
#import "AddCityViewController.h"


@interface HomeViewController ()
{
    BOOL isMenuOpen;
    MasterViewController *vcMaster;
    AddCityViewController *vcAddCity;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBackEnabled = NO;
    self.containerMain.layer.cornerRadius = 20.0;
    self.containerMain.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toMasterVC"]) {
        UINavigationController *nav = segue.destinationViewController;
        vcMaster = (MasterViewController*) nav.topViewController;
        vcMaster.vcHome = self;
    }
    
    
    if ([segue.identifier isEqualToString:@"toAddCityVC"]) {
        UINavigationController *nav = segue.destinationViewController;
        vcAddCity = (AddCityViewController*) nav.topViewController;
        vcAddCity.vcHome = self;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonMenuPressed:(id)sender {
    if (self.isBackEnabled) {
        //
        if ([self.delegateHomeVC respondsToSelector:@selector(menuPressed)]) {
            [self.delegateHomeVC menuPressed];
        }
    }
    else{
        
        if (isMenuOpen) {
            [self.viewMain setNeedsUpdateConstraints];
            [self.containerMain setNeedsUpdateConstraints];
            isMenuOpen = NO;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.constViewMainLeadingpos.constant = 0;
                [self.viewMain layoutIfNeeded];
                [self.containerMain layoutIfNeeded];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }
        else{
            //show menu
            [self.viewMain setNeedsUpdateConstraints];
            [self.containerMain setNeedsUpdateConstraints];
            isMenuOpen = YES;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.constViewMainLeadingpos.constant = 240;
                [self.viewMain layoutIfNeeded];
                [self.containerMain layoutIfNeeded];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
            }];
        }

    }

}
- (IBAction)buttonAddCityPressed:(id)sender {
    [self performSegueWithIdentifier:@"toAddCityVC" sender:self];
}
@end
