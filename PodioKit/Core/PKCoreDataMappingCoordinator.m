//
//  PKCoreDataMappingCoordinator.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 9/14/11.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import "PKCoreDataMappingCoordinator.h"
#import "PKCoreDataRepository.h"

@interface PKCoreDataMappingCoordinator ()

- (void)mappingContextDidSave:(NSNotification *)notification;

@end

@implementation PKCoreDataMappingCoordinator

@synthesize managedObjectContext = managedObjectContext_;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext 
                   mappingProvider:(PKMappingProvider *)mappingProvider {
  self = [super initWithMappingProvider:mappingProvider];
  if (self) {
    PKAssert(managedObjectContext.concurrencyType == NSMainQueueConcurrencyType, @"The object context must have a concurrency type NSMainQueueConcurrencyType");
    managedObjectContext_ = managedObjectContext;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mappingContextDidSave:)
                                                 name:NSManagedObjectContextDidSaveNotification 
                                               object:nil];
  }
  
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PKObjectMapper *)objectMapper {
  PKAssert(self.mappingProvider != nil, @"No mapping provider set.");
  
  PKCoreDataRepository *repository = [[PKCoreDataRepository alloc] initWithPersistentStoreCoordinator:self.managedObjectContext.persistentStoreCoordinator];
  
  PKObjectMapper *mapper = [[PKObjectMapper alloc] initWithProvider:self.mappingProvider repository:repository];
  mapper.delegate = self;
  
  return mapper;
}

- (void)mappingContextDidSave:(NSNotification *)notification {
  NSManagedObjectContext *savedContext = notification.object;
  
  // Only merge from other contexts
  if (savedContext == self.managedObjectContext) {
    return;
  }

  NSManagedObjectContext *context = self.managedObjectContext;
  [context performBlock:^{
    [context mergeChangesFromContextDidSaveNotification:notification];
  }];
}

#pragma mark - PKObjectMapperDelegate methods

- (void)objectMapperDidFinishMapping:(PKObjectMapper *)objectMapper {
  PKObjectMapper *mapper = (PKObjectMapper *)objectMapper;
  if ([mapper.repository isKindOfClass:[PKCoreDataRepository class]]) {
    NSManagedObjectContext *context = [(PKCoreDataRepository *)mapper.repository managedObjectContext];
    
    PKLogDebug(@"Inserted object count: %d", [[context insertedObjects] count]);
    PKLogDebug(@"Updated object count: %d", [[context updatedObjects] count]);
    PKLogDebug(@"Deleted object count: %d", [[context deletedObjects] count]);
    
    // Save context
    NSError *error = nil;
    if (![context save:&error]) {
      PKLogError(@"ERROR: Failed to save mapper context: %@, %@", error, [error userInfo]);
    }
  }
}


@end
