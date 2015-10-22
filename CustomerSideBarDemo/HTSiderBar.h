//
//  CustomSiderBar.h
//  CustomerSideBarDemo
//
//  Created by Huatan on 15/10/19.
//  Copyright © 2015年 Huatan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HTSiderBar;

@protocol HTSidebarDelegate <NSObject>
@optional
- (void)sidebar:(HTSiderBar *)sidebar willShowOnScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(HTSiderBar *)sidebar didShowOnScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(HTSiderBar *)sidebar willDismissFromScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(HTSiderBar *)sidebar didDismissFromScreenAnimated:(BOOL)animatedYesOrNo;
- (void)sidebar:(HTSiderBar *)sidebar didTapItemAtIndex:(NSUInteger)index;
@end

@interface HTSiderBar : UIViewController

// The width of the sidebar
// Default 150
@property (nonatomic, assign) CGFloat width;

// Access the view that contains the menu items
@property (nonatomic, strong, readonly) UITableView *contentView;

// The duration of the show and hide animations
// Default 0.25
@property (nonatomic, assign) CGFloat animationDuration;

// Toggle displaying the sidebar on the right side of the device
// Default NO
@property (nonatomic, assign) BOOL showFromRight;

// Toggle displaying the sidebar with shadow
// Default NO
@property (nonatomic, assign) BOOL hasShadow;

// An optional delegate to respond to interaction events
@property (nonatomic, weak) id <HTSidebarDelegate> delegate;


- (instancetype)initWithIcons:(NSArray *)icons andTitles:(NSArray *)titles;

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated;

- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
