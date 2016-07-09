//
//  HourlyViewController.h
//  iWeather
//
//  Created by Nikunj on 7/7/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import <UIKit/UIKit.h>

//This VC show hourly forecast details in the collection view. This VC is embeded inside a container view.

@interface HourlyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMain;

@end
