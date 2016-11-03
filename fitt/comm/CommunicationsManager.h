//
//  CommunicationsManager.h
//  fitt
//
//  Created by Nico Blodow on 02/11/16.
//  Copyright © 2016 Nico Blodow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeartRateSensor.h"
#import "Bike.h"

@interface CommunicationsManager : NSObject

@property (nonatomic, strong) HeartRateSensor* heartRateSensor;

+ (instancetype)sharedManager;

- (void)connect;
- (void)disconnect;

@end
