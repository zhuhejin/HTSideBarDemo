//
//  FirstViewController.m
//  CustomSideBarDemo
//
//  Created by Huatan on 15/10/22.
//  Copyright © 2015年 Huatan. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"page 1";
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 1000, 100)];
    lab.text = @"hello 11111";
    [self.view addSubview:lab];
}


@end
