//
//  SecondViewController.m
//  CustomSideBarDemo
//
//  Created by Huatan on 15/10/22.
//  Copyright © 2015年 Huatan. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"page 2";
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 1000, 100)];
    lab.text = @"hello 2222";
    [self.view addSubview:lab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
