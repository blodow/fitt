//
//  Bike.h
//  fitt
//
//  Created by Nico Blodow on 02/11/16.
//  Copyright © 2016 Nico Blodow. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WeakSet.h"

@protocol BikeObserver

- (void)bikeUpdateHeartRate:(float)rate;
- (void)bikeUpdateSpeed:(float)speed;
- (void)bikeLostDevice;

@end

@interface Bike : NSObject

@property (strong, nonatomic) WeakSet<NSObject<BikeObserver>*>* observers;

- (void)connect;

@end

