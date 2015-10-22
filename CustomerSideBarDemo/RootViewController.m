//
//  ViewController.m
//  CustomerSideBarDemo
//
//  Created by Huatan on 15/10/19.
//  Copyright © 2015年 Huatan. All rights reserved.
//

#import "RootViewController.h"
#import "HTSiderBar.h"

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface RootViewController ()<HTSidebarDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = menu;
    

}

- (void)showMenu {
    
    NSArray *itmes = @[
                       @{@"icon":@"menu",@"title":@"page1" },
                       @{@"icon":@"menu",@"title":@"page2" },
                        ];
    
    HTSiderBar *bar = [[HTSiderBar alloc] initWithItems:itmes];
    bar.delegate = self;
    bar.hasShadow = YES;
//    bar.showFromRight = YES;
    bar.width = 300;
    [bar show];
    
}

- (void)sidebar:(HTSiderBar *)sidebar didTapItemAtIndex:(NSUInteger)index{
    
    NSLog(@"selected index %lu",(unsigned long)index);
    
    UIViewController *vc;
    if (index == 0) {
        vc = [[FirstViewController alloc] init];

    }else{
        vc = [[SecondViewController alloc] init];
    }
    if ([self.navigationController.visibleViewController isKindOfClass:[vc class]]) {
        return;
    }
    
    [self.navigationController pushViewController:vc animated:NO];
    
    [sidebar dismissAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
