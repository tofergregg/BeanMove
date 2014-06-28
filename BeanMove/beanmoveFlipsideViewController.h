//
//  beanmoveFlipsideViewController.h
//  BeanMove
//
//  Created by Chris Gregg on 6/20/14.
//  Copyright (c) 2014 Chris Gregg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "beanmoveMainViewController.h"
#import "beanmoveFlipsideViewController.h"
#import "BEAN_Globals.h"
#import "PTDBeanManager.h"
#import "PTDBean.h"

@class beanmoveMainViewController;
@class beanmoveFlipsideViewController;

@protocol beanmoveFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(beanmoveFlipsideViewController *)controller;
@end

@interface beanmoveFlipsideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
        beanmoveMainViewController *mainViewController;
}

@property (weak, nonatomic) id <beanmoveFlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *scanTable;
@property (nonatomic, retain) beanmoveMainViewController* mainViewController;
@property (nonatomic, retain) IBOutlet UILabel *beanConnectedLabel;

- (IBAction)done:(id)sender;

@end
