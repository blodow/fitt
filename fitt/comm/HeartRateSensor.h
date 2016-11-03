//
//  HeartRateSensor.h
//  fitt
//
//  Created by Nico Blodow on 02/11/16.
//  Copyright © 2016 Nico Blodow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#include "WeakSet.h"

@protocol HeartRateSensorObserver

- (void)heartRateUpdateHeartRate:(float)rate;
- (void)heartRateUpdateBattery:(float)level;
- (void)heartRateLostDevice;

@end

@interface HeartRateSensor : NSObject <CBPeripheralDelegate>

@property (strong, nonatomic) WeakSet<NSObject<HeartRateSensorObserver>*>* observers;
@property (strong, nonatomic) CBPeripheral* peripheral;

- (void)connect;

@end
