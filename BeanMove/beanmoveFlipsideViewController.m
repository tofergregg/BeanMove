//
//  beanmoveFlipsideViewController.m
//  BeanMove
//
//  Created by Chris Gregg on 6/20/14.
//  Copyright (c) 2014 Chris Gregg. All rights reserved.
//

#import "beanmoveFlipsideViewController.h"

@interface beanmoveFlipsideViewController ()

@end

@implementation beanmoveFlipsideViewController

@synthesize scanTable;
@synthesize mainViewController;
@synthesize beanConnectedLabel;

- (void)viewDidLoad
{
        [super viewDidLoad];

        if (mainViewController.bean.state == BeanState_ConnectedAndValidated) {
                NSError *err;
                [mainViewController.beanManager disconnectBean:mainViewController.bean error:&err];
                [mainViewController.beanManager startScanningForBeans_error:&err];

        } else {
                if(mainViewController.beanManager.state == BeanManagerState_PoweredOn) {
                        NSError *err;
                        [mainViewController.beanManager startScanningForBeans_error:&err];
                        if (err) {
                                NSLog(@"Error:%@",err);
                        }
                } else {
                        NSLog(@"Bean Manager not powered on");
                }
        }
        [scanTable setAllowsSelection:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

#pragma mark tableview methods

// just returns the number of items we have.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [mainViewController.beans count];
}
        
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *simpleTableIdentifier = @"SimpleTableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        PTDBean *newBean = [mainViewController.beans objectAtIndex:indexPath.row];
        cell.textLabel.text = [newBean name];
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        NSLog(@"touched row %lu",(long)indexPath.row);
        // connect bean
        [mainViewController.beanManager stopScanningForBeans_error:nil];

        mainViewController.bean = [mainViewController.beans objectAtIndex:indexPath.row];
        mainViewController.bean.delegate = mainViewController;
        beanConnectedLabel.text = [mainViewController bean].name;
        
        [mainViewController.beanManager connectToBean:mainViewController.bean error:nil];
        /*[self.updateTimer invalidate];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                          target:self selector:@selector(updateAll)
                                                        userInfo:nil repeats:YES];
                self.updateTimer = timer;*/
}

@end
