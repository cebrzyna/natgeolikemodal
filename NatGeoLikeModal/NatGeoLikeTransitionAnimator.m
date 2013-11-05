//
//  NatGeoLikeTransitionAnimator.m
//  NatGeoLikeModal
//
//  Created by jcebrzyna on 05/11/13.
//  Copyright (c) 2013 jcebrzyna. All rights reserved.
//

#import "NatGeoLikeTransitionAnimator.h"

@interface NatGeoLikeTransitionAnimator ()

@property (nonatomic, assign) CGFloat transitionDuration;
@property (nonatomic, assign) CATransform3D t1;
@property (nonatomic, assign) CATransform3D t2;
@property (nonatomic, assign) CATransform3D t3;

@property(nonatomic, assign) CGRect modalVCFrameBeforeAnimation;
@property(nonatomic, assign) CGRect modalVCFrameAfterAnimation;

@end

@implementation NatGeoLikeTransitionAnimator

-(id) initWithTransitionDuration:(CGFloat) transitionDuration{
    self = [super init];
    if(self){
        self.transitionDuration = transitionDuration;
    }
    
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    self.presenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presenting = NO;
    return self;
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *modalViewController = nil;
    if(self.presenting){
        modalViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
#warning disable user interaction
  //      [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }else{
        #warning enable user interaction
        modalViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//        viewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    }
    
    UIView *container = [transitionContext containerView];
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    BOOL isPortrait = ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown);
    
    CALayer *layer = container.layer;
    CGSize containerSize;
    if (isPortrait) {
        [self setAnchorPoint:CGPointMake(0.5, 1.0) forView:container];
        containerSize = container.frame.size;
    }else{
        [self setAnchorPoint:CGPointMake(1.0, 0.5) forView:container];
        containerSize = container.frame.size;
    }
    
    //initialize views position
    CGSize modalViewControllerStartSize = modalViewController.view.bounds.size;
    if (self.presenting) {
        [[container superview] addSubview:modalViewController.view];
        if (isPortrait) {
            self.modalVCFrameBeforeAnimation = CGRectMake((containerSize.width - modalViewControllerStartSize.width)/ 2.0,
                                                     (containerSize.height - modalViewControllerStartSize.height) + modalViewControllerStartSize.height,
                                                     modalViewControllerStartSize.height,
                                                     modalViewControllerStartSize.width);
            self.modalVCFrameAfterAnimation = CGRectMake((containerSize.width - modalViewControllerStartSize.width)/ 2.0,
                                                        (containerSize.height - modalViewControllerStartSize.height),
                                                        modalViewControllerStartSize.height,
                                                        modalViewControllerStartSize.width);
        }else{
            self.modalVCFrameBeforeAnimation = CGRectMake((containerSize.width - modalViewControllerStartSize.width) + modalViewControllerStartSize.width,
                                                     (containerSize.height - modalViewControllerStartSize.height)/2.0,
                                                     modalViewControllerStartSize.height,
                                                     modalViewControllerStartSize.width);
            self.modalVCFrameAfterAnimation = CGRectMake((containerSize.width - modalViewControllerStartSize.width),
                                                      (containerSize.height - modalViewControllerStartSize.height)/2.0,
                                                      modalViewControllerStartSize.height,
                                                      modalViewControllerStartSize.width);
        }
        modalViewController.view.frame = self.modalVCFrameBeforeAnimation;
    }else{
        
    }
    //animations
    if(self.presenting){
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
            
            {
                CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                rotationAndPerspectiveTransform.m34 = 1.0 / -500.0;
                layer.transform = rotationAndPerspectiveTransform;
                self.t1 = rotationAndPerspectiveTransform;
            }
            [UIView addKeyframeWithRelativeStartTime:0
                                    relativeDuration:0.23
                                          animations:^{
                                              float scale = 0.9;
                                              if (isPortrait) {
                                                  layer.transform = CATransform3DTranslate(layer.transform, 0, - (containerSize.width * 0.05), 0);
                                              }else{
                                                  layer.transform = CATransform3DTranslate(layer.transform, - (containerSize.height * 0.05), 0, 0);
                                              }
                                              layer.transform = CATransform3DScale(layer.transform, scale, scale, 1.0);
                                              self.t2 = layer.transform ;
                                          }];
            
            
            [UIView addKeyframeWithRelativeStartTime:0.23
                                    relativeDuration:0.54
                                          animations:^{
                                              CATransform3D rotationAndPerspectiveTransform = layer.transform;
                                              if (isPortrait) {
                                                  rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, 2.0 * M_PI / 180.0, 1.0f, 0.0f, 0.0f);
                                              }else{
                                                  rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -2.0 * M_PI / 180.0, 0.0f, 1.0f, 0.0f);
                                              }
                                              layer.transform = rotationAndPerspectiveTransform;
                                              self.t3 =rotationAndPerspectiveTransform;
                                          }];
            
            
            [UIView addKeyframeWithRelativeStartTime:0.77
                                    relativeDuration:0.23
                                          animations:^{
                                              float scale = 0.8;
                                              CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
                                              if (isPortrait) {
                                                  rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, 0, - (containerSize.width * 0.1), 0);
                                              }else{
                                                  rotationAndPerspectiveTransform = CATransform3DTranslate(rotationAndPerspectiveTransform, - (containerSize.height * 0.1), 0, 0);
                                              }
                                              rotationAndPerspectiveTransform = CATransform3DScale(rotationAndPerspectiveTransform, scale, scale, 1.0);
                                              layer.transform = rotationAndPerspectiveTransform;
                                          }];

            [UIView addKeyframeWithRelativeStartTime:0.20
                                    relativeDuration:0.80
                                          animations:^{
                                              modalViewController.view.frame = self.modalVCFrameAfterAnimation;
                                          }];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
        
    }else{
        {
            CATransform3D rotationAndPerspectiveTransform = layer.transform;
            rotationAndPerspectiveTransform.m34 = 1.0 / -500.0;
            layer.transform = rotationAndPerspectiveTransform;
        }
        [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0
                                    relativeDuration:0.23
                                          animations:^{
                                              layer.transform = self.t3;
                                          }];
            
            
            [UIView addKeyframeWithRelativeStartTime:0.23
                                    relativeDuration:0.54
                                          animations:^{
                                              layer.transform = self.t2;
                                          }];
            
            
            [UIView addKeyframeWithRelativeStartTime:0.77
                                    relativeDuration:0.23
                                          animations:^{
                                              layer.transform = self.t1;
                                          }];
            
            modalViewController.view.frame = self.modalVCFrameBeforeAnimation;
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:finished];
        }];
    }
}

@end