//
//  NSArray+PKAdditions.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 7/20/11.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import "NSArray+PKAdditions.h"


@implementation NSArray (PKAdditions)

- (NSArray *)pk_arrayFromObjectsCollectedWithBlock:(id (^)(id obj))block {
  NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:[self count]];
  
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    [mutArray addObject:block(obj)];
  }];
  
  NSArray *array = [mutArray copy];
  
  return array;
}

- (NSArray *)pk_filteredArrayUsingBlock:(BOOL (^)(id obj))block {
  NSMutableArray *mutArray = [[NSMutableArray alloc] init];
  
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    if (block(obj)) {
      [mutArray addObject:obj];
    }
  }];
  
  NSArray *array = [mutArray copy];
  
  return array;
}

- (id)pk_firstObject {
  id obj = nil;
  if ([self count] > 0) {
    obj = [self objectAtIndex:0];
  }
  
  return obj;
}

@end
