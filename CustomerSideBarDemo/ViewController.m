//
//  ViewController.m
//  CustomerSideBarDemo
//
//  Created by Huatan on 15/10/19.
//  Copyright © 2015年 Huatan. All rights reserved.
//

#import "ViewController.h"
#import "HTSiderBar.h"

@interface ViewController ()<HTSidebarDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"demo";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
     self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    // Do any additional setup after loading the view, typically from a nib.

    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = menu;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 1000, 100)];
    lab.text = @"hello";
    [self.view addSubview:lab];
}

- (void)showMenu {
    
    NSArray *images = @[
                        [UIImage imageNamed:@"menu@2x"],
                        [UIImage imageNamed:@"menu@2x"]
                        ];
    NSArray *titles = @[
                        @"111",
                        @"222",
                        ];

    
    HTSiderBar *bar = [[HTSiderBar alloc] initWithIcons:images andTitles:titles];
    bar.delegate = self;
//    bar.hasShadow = YES;
//    bar.showFromRight = YES;
    bar.width = 300;
    [bar show];
    
}

- (void)sidebar:(HTSiderBar *)sidebar didTapItemAtIndex:(NSUInteger)index{
    NSLog(@"selected index %lu",(unsigned long)index);
    if (index == 1) {
        [sidebar dismissAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
