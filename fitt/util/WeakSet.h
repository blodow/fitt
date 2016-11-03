//
//  WeakSet
//  fitt
//
//  Created by Nico Blodow on 02/11/16.
//  Copyright © 2016 Nico Blodow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakSet<__covariant ObjectType> : NSObject

- (void)addObject:(ObjectType)obj;
- (void)removeObject:(ObjectType)obj;
- (void)enumerateObjectsUsingBlock:(void(^)(ObjectType))action;

@end
