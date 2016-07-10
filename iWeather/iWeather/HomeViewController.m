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
#import "CoredataManager.h"
#import "MenuTableViewController.h"



@interface HomeViewController () <MenuTableViewControllerDelegate>
{
    BOOL isMenuOpen;
    AddCityViewController *vcAddCity;
    MenuTableViewController *vcMenu;
}
@property (nonatomic,strong) MasterViewController *vcMaster;

@end

@implementation HomeViewController

@synthesize isBackEnabled;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBackEnabled = NO;
    self.containerMain.layer.cornerRadius = 20.0;
    self.containerMain.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
//    [CoredataManager fetchAllCitiesFromLocal:^(NSArray *arraySavedCities) {
//        
//    }];

    [self addObserver:self forKeyPath:@"isBackEnabled" options:0 context:nil];
    [self.vcMaster refreshData];
    
}   

-(void)viewDidDisappear:(BOOL)animated{
    [self removeObserver:self forKeyPath:@"isBackEnabled"];
}

#pragma mark Delegate Menu

-(void)tempUnitChanged{
    [self.vcMaster refreshData];
}

-(void)openSourcePressed{
    [self buttonMenuPressed:self];
    [self performSegueWithIdentifier:@"toWebVC" sender:self];
}

-(void)addNewCityPressed{
    [self buttonMenuPressed:self];
    [self buttonAddCityPressed:self];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if (object==self && [keyPath isEqualToString:@"isBackEnabled"]) {
        if (self.isBackEnabled) {
            [self.imageviewMenuBack setImage:[UIImage imageNamed:@"back"]];
        }
        else{
            [self.imageviewMenuBack setImage:[UIImage imageNamed:@"menu"]];
        }
    }
}

//-(void)setIsBackEnabled:(BOOL)isBackEnabled{
//    if (isBackEnabled) {
//        [self.imageviewMenuBack setImage:[UIImage imageNamed:@"back"]];
//    }
//    else{
//        [self.imageviewMenuBack setImage:[UIImage imageNamed:@"menu"]];
//    }
//    _isBackEnabled = isBackEnabled;
//}





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"toMasterVC"]) {
        UINavigationController *nav = segue.destinationViewController;
        self.vcMaster = (MasterViewController*) nav.topViewController;
        self.vcMaster.vcHome = self;
    }
    
    
    if ([segue.identifier isEqualToString:@"toAddCityVC"]) {
        UINavigationController *nav = segue.destinationViewController;
        vcAddCity = (AddCityViewController*) nav.topViewController;
        vcAddCity.vcHome = self;
    }
    
    if ([segue.identifier isEqualToString:@"toSideMenu"]) {
        vcMenu = segue.destinationViewController;
        vcMenu.delegateMenu = self;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonMenuPressed:(id)sender {
    if (self.isBackEnabled) {
        //
        [self.buttonhiddenMenu setHidden:YES];
        if ([self.delegateHomeVC respondsToSelector:@selector(menuPressed)]) {
            [self.delegateHomeVC menuPressed];
        }
    }
    else{
        
        if (isMenuOpen) {
            [self.buttonhiddenMenu setHidden:YES];
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
            [self.buttonhiddenMenu setHidden:NO];
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
