//
//  WebVC.m
//  iWeather
//
//  Created by Nikunj on 7/10/16.
//  Copyright © 2016 Nikunj. All rights reserved.
//

#import "WebVC.h"

@implementation WebVC


-(void)viewDidLoad{
    [super viewDidLoad];
    [self.webviewMain loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"opens" ofType:@"html"]isDirectory:NO]]];

}

- (IBAction)buttonClosePressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
