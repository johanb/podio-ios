//
//  PKStreamItemData.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 9/20/11.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import "PKStreamItemData.h"


static NSString * const PKStreamItemDataItemId = @"ItemId";
static NSString * const PKStreamItemDataTitle = @"Title";

@implementation PKStreamItemData

@synthesize itemId = itemId_;
@synthesize title = title_;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    itemId_ = [aDecoder decodeIntegerForKey:PKStreamItemDataItemId];
    title_ = [[aDecoder decodeObjectForKey:PKStreamItemDataTitle] copy];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [super encodeWithCoder:aCoder];
  [aCoder encodeInteger:itemId_ forKey:PKStreamItemDataItemId];
  [aCoder encodeObject:title_ forKey:PKStreamItemDataTitle];
}


#pragma mark - Factory methods

+ (id)dataFromDictionary:(NSDictionary *)dict {
  PKStreamItemData *data = [self data];
  data.itemId = [[dict pk_objectForKey:@"item_id"] integerValue];
  data.title = [dict pk_objectForKey:@"title"];
  
  return data;
}

@end
