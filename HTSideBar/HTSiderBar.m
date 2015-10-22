//
//  CustomSiderBar.m
//  CustomerSideBarDemo
//
//  Created by Huatan on 15/10/19.
//  Copyright © 2015年 Huatan. All rights reserved.
//

#import "HTSiderBar.h"


@implementation UIView (rn_Screenshot)

- (UIImage *)rn_screenshot {
    UIGraphicsBeginImageContext(self.bounds.size);
    if([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]){
        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    }
    else{
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    return image;
}

@end


@interface HTSiderBar ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *contentView;
@property (nonatomic, strong) UIImageView *blurView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) NSMutableArray *iconViews;
@property (nonatomic, strong) NSMutableArray *titles;

@end

static HTSiderBar *rn_frostedMenu;

@implementation HTSiderBar

- (instancetype)initWithIcons:(NSArray *)icons andTitles:(NSArray *)titles{
    self = [super init];
    if (self) {
        _animationDuration = 0.25f;
        _width = 150;
        _iconViews = [icons mutableCopy];
        _titles = [titles mutableCopy];
        _hasShadow = NO;
    }
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"Unable to create with plain init.");
    return nil;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tapGesture.delegate = self;
    [self.view addGestureRecognizer:self.tapGesture];
}

- (BOOL)shouldAutorotate {
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 90000  

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

#endif



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if ([self isViewLoaded] && self.view.window != nil) {
        self.view.alpha = 0;
        UIImage *blurImage = [self.parentViewController.view rn_screenshot];
        self.blurView.image = blurImage;
        self.view.alpha = 1;
        
        [self.contentView reloadData];
    }
}


#pragma mark - Show

- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated {
    if (rn_frostedMenu != nil) {
        [rn_frostedMenu dismissAnimated:NO completion:nil];
    }
    
    if ([self.delegate respondsToSelector:@selector(sidebar:willShowOnScreenAnimated:)]) {
        [self.delegate sidebar:self willShowOnScreenAnimated:animated];
    }
    
    rn_frostedMenu = self;
    
    UIImage *blurImage = [controller.view rn_screenshot];
    [self rn_addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = self.view.bounds.size.width;
    
    CGRect contentFrame = self.view.bounds;
    contentFrame.origin.x = _showFromRight ? parentWidth : -_width;
    contentFrame.size.width = _width;
    self.contentView.frame = contentFrame;
    
    CGRect blurFrame = CGRectMake(_showFromRight ? self.view.bounds.size.width : 0, 0, 0, self.view.bounds.size.height);
    
    self.blurView = [[UIImageView alloc] initWithImage:blurImage];
    self.blurView.frame = blurFrame;
    self.blurView.contentMode = _showFromRight ? UIViewContentModeTopRight : UIViewContentModeTopLeft;
    self.blurView.clipsToBounds = YES;
    [self.view insertSubview:self.blurView belowSubview:self.contentView];
    
    contentFrame.origin.x = _showFromRight ? parentWidth - _width : 0;
    blurFrame.origin.x = contentFrame.origin.x;
    blurFrame.size.width = _width;
    
    if (self.hasShadow) {
        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        _contentView.layer.masksToBounds = NO;
        _contentView.layer.shadowOffset = CGSizeMake(0, 5);
        _contentView.layer.shadowRadius = 5;
        _contentView.layer.shadowOpacity = 0.5;
    }
    
    void (^animations)() = ^{
        self.contentView.frame = contentFrame;
        self.blurView.frame = blurFrame;
    };
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (finished && [self.delegate respondsToSelector:@selector(sidebar:didShowOnScreenAnimated:)]) {
            [self.delegate sidebar:self didShowOnScreenAnimated:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:kNilOptions
                         animations:animations
                         completion:completion];
    }
    else{
        animations();
        completion(YES);
    }
}

- (void)showAnimated:(BOOL)animated {
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (controller.presentedViewController != nil) {
        controller = controller.presentedViewController;
    }
    [self showInViewController:controller animated:animated];
}

- (void)show {
    [self showAnimated:YES];
}

#pragma mark - Dismiss

- (void)dismiss {
    [self dismissAnimated:YES completion:nil];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissAnimated:animated completion:nil];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    void (^completionBlock)(BOOL) = ^(BOOL finished){
        [self rn_removeFromParentViewControllerCallingAppearanceMethods:YES];
        
        if ([self.delegate respondsToSelector:@selector(sidebar:didDismissFromScreenAnimated:)]) {
            [self.delegate sidebar:self didDismissFromScreenAnimated:YES];
        }
        
        rn_frostedMenu = nil;
        
        if (completion) {
            completion(finished);
        }
    };
    
    if ([self.delegate respondsToSelector:@selector(sidebar:willDismissFromScreenAnimated:)]) {
        [self.delegate sidebar:self willDismissFromScreenAnimated:YES];
    }
    
    if (animated) {
        CGFloat parentWidth = self.view.bounds.size.width;
        CGRect contentFrame = self.contentView.frame;
        contentFrame.origin.x = self.showFromRight ? parentWidth : -_width;
        
        CGRect blurFrame = self.blurView.frame;
        blurFrame.origin.x = self.showFromRight ? parentWidth : 0;
        blurFrame.size.width = 0;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.contentView.frame = contentFrame;
                             self.blurView.frame = blurFrame;
                         }
                         completion:completionBlock];
    }
    else {
        completionBlock(YES);
    }
}

- (void)rn_addToParentViewController:(UIViewController *)parentViewController callingAppearanceMethods:(BOOL)callAppearanceMethods {
    if (self.parentViewController != nil) {
        [self rn_removeFromParentViewControllerCallingAppearanceMethods:callAppearanceMethods];
    }
    
    if (callAppearanceMethods) [self beginAppearanceTransition:YES animated:NO];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

- (void)rn_removeFromParentViewControllerCallingAppearanceMethods:(BOOL)callAppearanceMethods {
    if (callAppearanceMethods) [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

#pragma mark - Gestures

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self.view];
    if (! CGRectContainsPoint(self.contentView.frame, location)) {
        [self dismissAnimated:YES completion:nil];
    }
}

//fixed the confilct between uitableview and tapgesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if([touch.view isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCell
    if([touch.view.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    // UITableViewCellContentView => UITableViewCellScrollView => UITableViewCell
    if([touch.view.superview.superview isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    return YES; // handle the touch
}


#pragma mark - UItableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_iconViews count];;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = @"111";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(sidebar:didTapItemAtIndex:)]) {
        [self.delegate sidebar:self didTapItemAtIndex:indexPath.row];
    }
}

- (UITableView *)contentView {
    if (!_contentView) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        
        [_contentView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self setExtraCellLineHidden:_contentView];
    }
    return _contentView;
}

//去掉多余的分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
