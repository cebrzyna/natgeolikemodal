//
//  NatGeoLikeTransitionAnimator.h
//  NatGeoLikeModal
//
//  Created by jcebrzyna on 05/11/13.
//  Copyright (c) 2013 jcebrzyna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NatGeoLikeTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

-(id) initWithTransitionDuration:(CGFloat) transitionDuration;

@property (nonatomic, assign, getter = isPresenting) BOOL presenting;


@end
