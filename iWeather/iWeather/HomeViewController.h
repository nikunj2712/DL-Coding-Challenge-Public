//
//  ViewController.h
//  iWeather
//
//  Created by Nikunj on 7/7/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//


//This viewcontroller holds container views that has SideMenuVC, MasterVC, this VC only deals with full app navigation.



@protocol HomeViewControllerDelegate <NSObject>


@optional
-(void)menuPressed;
-(void)backPressed;


@end
#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController

@property(nonatomic,weak) id <HomeViewControllerDelegate> delegateHomeVC;

@property (weak, nonatomic) IBOutlet UIButton *buttonMenu;
- (IBAction)buttonMenuPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddCity;
- (IBAction)buttonAddCityPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerSideMenu;
@property (weak, nonatomic) IBOutlet UIView *containerMain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constViewMainCenterX;

@property(nonatomic) BOOL isBackEnabled;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constViewMainLeadingpos;
@property (weak, nonatomic) IBOutlet UIView *viewMain;
@property (weak, nonatomic) IBOutlet UIImageView *imageviewMenuBack;
@property (weak, nonatomic) IBOutlet UIButton *buttonhiddenMenu;

@end

