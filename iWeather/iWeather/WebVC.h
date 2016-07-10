//
//  WebVC.h
//  iWeather
//
//  Created by Nikunj on 7/10/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebVC : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webviewMain;

- (IBAction)buttonClosePressed:(id)sender;
@end
