//
//  ModalViewController.m
//  NatGeoLikeModal
//
//  Created by jcebrzyna on 05/11/13.
//  Copyright (c) 2013 jcebrzyna. All rights reserved.
//

#import "ModalViewController.h"

@interface ModalViewController ()

@end

@implementation ModalViewController

-(IBAction)doneWasPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
