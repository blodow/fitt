//
//  ConsoleLogger.m
//  fitt
//
//  Created by Nico Blodow on 03/11/16.
//  Copyright © 2016 Nico Blodow. All rights reserved.
//

#import "ConsoleLogger.h"

@implementation ConsoleLogger

#pragma mark - BikeObserver implementation

- (void)bikeLostDevice
{
    NSLog(@"lost bike device");
}

- (void)bikeUpdateSpeed:(float)speed
{
    NSLog(@"bike speed update: %f", speed);
}

- (void)bikeUpdateHeartRate:(float)rate
{
    NSLog(@"bike heart rate update: %f", rate);
}

#pragma mark - HeartRateSensorObserver implementation

- (void)heartRateLostDevice
{
    NSLog(@"lost heart rate sensor device");
}

- (void)heartRateUpdateHeartRate:(float)rate
{
    NSLog(@"heart rate update: %f", rate);
}

- (void)heartRateUpdateBattery:(float)level
{
    NSLog(@"heart rate battery update: %f", level);
}


@end
