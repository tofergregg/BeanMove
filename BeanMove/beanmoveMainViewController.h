//
//  beanmoveMainViewController.h
//  BeanMove
//
//  Created by Chris Gregg on 6/20/14.
//  Copyright (c) 2014 Chris Gregg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "beanmoveFlipsideViewController.h"
#import "beanmoveMainViewController.h"
#import "BEAN_Globals.h"
#import "PTDBeanManager.h"
#import "PTDBean.h"

@class AVAudioPlayer;

@class beanmoveFlipsideViewController;

@interface beanmoveMainViewController : UIViewController <PTDBeanDelegate, PTDBeanManagerDelegate> {
        PTDBean *bean;
        beanmoveFlipsideViewController *flipsideController;
        NSLock *threadLock;
        int delay;
}

@property (atomic,retain) PTDBeanManager *beanManager;
@property (atomic,retain) NSMutableArray *beans; // the BLE devices we find
@property (atomic,retain) PTDBean *bean;
@property (atomic,retain) beanmoveFlipsideViewController *flipsideController;
@property (assign) IBOutlet UITextField *accText;
@property (weak) NSTimer *updateTimer;
@property (atomic,retain) NSLock *threadLock;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic,weak) IBOutlet UIView *rightArrow;
@property (nonatomic,weak) IBOutlet UIView *leftArrow;

- (void)updateAll;
- (void)disconnect;
- (void)beep;
- (void) animateArrow:(UIView *)arrow;

@end
