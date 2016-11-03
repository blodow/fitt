//
//  ConsoleLogger.h
//  fitt
//
//  Created by Nico Blodow on 03/11/16.
//  Copyright © 2016 Nico Blodow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeartRateSensor.h"
#import "Bike.h"

@interface ConsoleLogger : NSObject <HeartRateSensorObserver, BikeObserver>

@end
