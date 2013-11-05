//
//  ViewController.m
//  NatGeoLikeModal
//
//  Created by jcebrzyna on 05/11/13.
//  Copyright (c) 2013 jcebrzyna. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.animator = [[NatGeoLikeTransitionAnimator alloc] initWithTransitionDuration:0.6f];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    UIViewController *detailViewController = segue.destinationViewController;
    detailViewController.view.bounds = CGRectMake(0, 0, 300, 300);
    
    detailViewController.transitioningDelegate = self.animator;
    detailViewController.modalPresentationStyle = UIModalPresentationCustom;
}



@end
