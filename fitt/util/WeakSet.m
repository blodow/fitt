//
//  WeakSet.m
//  fitt
//
//  Created by Nico Blodow on 02/11/16.
//  Copyright © 2016 Nico Blodow. All rights reserved.
//

#import "WeakSet.h"

typedef id(^Getter)();

@interface WeakSet ()

@property (nonatomic, strong) NSMutableSet<Getter>* objects;

@end

@implementation WeakSet

- (id)init
{
    self = [super init];
    if (self) {
        _objects = [[NSMutableSet alloc] init];
    }
    return self;
}


- (void)addObject:(id)obj
{
    __weak typeof(obj) weakObj = obj;
    
    Getter getter = ^id() {
        return weakObj;
    };
    
    [self.objects addObject:[getter copy]];
}

- (void)removeObject:(id)obj
{
    [self enumerateObserversDelete:^BOOL(id o, BOOL *stop) {
        bool found = [o isEqual:obj];
        *stop = found; // stop once we found it
        return found; // we should delete it too
    }];
}

- (void)enumerateObjectsUsingBlock:(void (^)(id))action
{
    [self enumerateObserversDelete:^BOOL(id o, BOOL *stop) {
        action(o); // call action with observable
        return NO; // never delete
    }];
}

- (void)enumerateObserversDelete:(BOOL(^)(id o, BOOL* stop))shouldDelete
{
    NSMutableSet<Getter>* remove = [NSMutableSet set];
    
    [self.objects enumerateObjectsUsingBlock:^(Getter get, BOOL* stop) {
        BOOL shouldStop = NO;
        
        id o = get();
        if (!o || shouldDelete(o, &shouldStop)) {
            [remove addObject:get];
        }
        *stop = shouldStop;
    }];
    
    [remove enumerateObjectsUsingBlock:^(Getter get, BOOL* stop) {
        [self.objects removeObject:get];
    }];
}



@end
