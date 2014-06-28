//
//  beanmoveMainViewController.m
//  BeanMove
//
//  Created by Chris Gregg on 6/20/14.
//  Copyright (c) 2014 Chris Gregg. All rights reserved.
//

#import "beanmoveMainViewController.h"

@interface beanmoveMainViewController ()

@end

@implementation beanmoveMainViewController

@synthesize beanManager, beans, bean;
@synthesize flipsideController,accText;
@synthesize leftArrow,rightArrow;
@synthesize threadLock;

- (void)viewDidLoad
{
        [super viewDidLoad];
        delay = 0;
        
        leftArrow.hidden = YES;
        rightArrow.hidden = YES;

        
        if (!beans) beans = [NSMutableArray array];
        if (beans.count > 0) [beans removeAllObjects];
        if (!beanManager) beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
        self.updateTimer = nil;
        threadLock = [[NSLock alloc] init]; // lock for the bean

}

- (IBAction)done:(UIStoryboardSegue *)segue {
        // start the timer
        [self.updateTimer invalidate];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self selector:@selector(updateAll)
                                                        userInfo:nil repeats:YES];
        self.updateTimer = timer;
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(beanmoveFlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        [self.updateTimer invalidate];
        if (beans.count > 0) {
                [threadLock lock];
                [beans removeAllObjects];
                [threadLock unlock];
        }
        // enable information to be passed between viewControllers
        flipsideController = segue.destinationViewController;
        flipsideController.mainViewController = self;
}

#pragma mark Bean Delegate Methods
// check to make sure we're on
- (void)beanManagerDidUpdateState:(PTDBeanManager *)manager{
        
}
// bean discovered
- (void)BeanManager:(PTDBeanManager*)beanManager didDiscoverBean:(PTDBean*)aBean error:(NSError*)error{
        if (error) {
                PTDLog(@"%@", [error localizedDescription]);
                return;
        }
        if( ![self.beans containsObject:aBean] ){
                NSLog(@"Name: '%@',%ld",[aBean name],[self.beans count]);
                
                [self.beans addObject:aBean];
        }
        [flipsideController.scanTable reloadData];
        NSLog(@"Updated Bean in Scan Window: %@",[((PTDBean *)self.beans[0]) name]);
        //[self.beanManager connectToBean:bean error:nil];
}
// bean connected
- (void)BeanManager:(PTDBeanManager*)beanManager didConnectToBean:(PTDBean*)bean error:(NSError*)error{
        if (error) {
                PTDLog(@"%@", [error localizedDescription]);
                return;
        }
        // do stuff with your bean
        NSLog(@"Bean connected!");
        //[connectionProgress stopAnimation:self];
        //[connectedLabel setStringValue:connectedCheck];
        
}

- (void)BeanManager:(PTDBeanManager*)beanManager didDisconnectBean:(PTDBean*)bean error:(NSError*)error {
        NSLog(@"Bean disconnected.");
        //[connectedLabel setStringValue:disconnectedX];
}

-(void)bean:(PTDBean *)bean didUpdateAccelerationAxes:(PTDAcceleration)acceleration {
        if (delay > 0 && delay++ < 10) return; // delay for bounce
        delay = 0;
        
        NSLog(@"acc:%f,%f,%f",acceleration.x,acceleration.y,acceleration.z);
        accText.text = [NSString stringWithFormat:@"%f",acceleration.x];
        if (acceleration.x > 0.1) {
                [self beep];
                [self animateArrow:rightArrow];
                delay++;
                NSLog(@"right");
        }
        else if (acceleration.x < -0.1) {
                [self beep];
                [self animateArrow:leftArrow];
                delay++;
                NSLog(@"left");
        }
        else {
                NSLog(@"None.");
        }
}


- (void)updateAll {
        static unsigned long counter = 0;
        
        // wait for bean to connect
        if (bean.state == BeanState_ConnectedAndValidated) {
                [bean readAccelerationAxis];
                counter++;
        }
}

- (void)disconnect {
        
        [threadLock lock]; // Must invalidate timer in a lock?
        [self.updateTimer invalidate];
        [threadLock unlock];
        
        [beanManager disconnectBean:bean error:nil];
}

- (void)beep {
        // Get the file path to the song to play.
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"swoosh"
                                                             ofType:@"mp3"];
        
        // Convert the file path to a URL.
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
        
        //Initialize the AVAudioPlayer.
        self.audioPlayer = [[AVAudioPlayer alloc]
                            initWithContentsOfURL:fileURL error:nil];
        
        // Preloads the buffer and prepares the audio for playing.
        [self.audioPlayer prepareToPlay];
        
        // Make sure the audio is at the start of the stream.
        self.audioPlayer.currentTime = 0;
        
        [self.audioPlayer play];
}
- (void) animateArrow:(UIView *)arrow {
        CGRect animationArrow = arrow.frame;
        
        if ([arrow isEqual:leftArrow]) {
                arrow.frame = CGRectMake(320,25,240,128);
                animationArrow.origin.x = -320;
        }
        else {
                arrow.frame = CGRectMake(-200,25,240,128);
                animationArrow.origin.x = 320;
        }
        arrow.hidden = NO;

        [UIView animateWithDuration:0.8
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^{
                                 arrow.frame = animationArrow;
                         }
                         completion:^(BOOL finished){
                                 arrow.hidden = YES;
                                 NSLog(@"Done!");
                         }];
}

@end
