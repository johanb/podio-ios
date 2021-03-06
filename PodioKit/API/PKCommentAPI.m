//
//  PKCommentAPI.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 11/28/11.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import "PKCommentAPI.h"

@implementation PKCommentAPI

+ (PKRequest *)requestForPostCommentWithText:(NSString *)text referenceId:(NSUInteger)referenceId referenceType:(PKReferenceType)referenceType {
	NSString * uri = [NSString stringWithFormat:@"/comment/%@/%d/", [PKConstants stringForReferenceType:referenceType], referenceId];
  PKRequest *request = [PKRequest requestWithURI:uri method:PKRequestMethodPOST objectMapping:nil];
	request.body = @{@"value": text};
  
  return request;
}

@end
