//
//  ADNChannel.m
//  wry
//
//  Created by Rob Warner on 5/13/13.
//  Copyright (c) 2013 Rob Warner. All rights reserved.
//

#import "ADNChannel.h"
#import "ADNUser.h"
#import "ADNAnnotation.h"
#import "ADNAccessControlList.h"

@implementation ADNChannel

static NSDictionary *NamesForTypes;

+ (void)initialize {
  NamesForTypes = @{
    @"net.patter-app.room" : @"Patter",
    @"net.app.core.pm" : @"Private"
  };
}

+ (NSString *)nameForType:(NSString *)type {
  return [[NamesForTypes allKeys] containsObject:type] ? [NamesForTypes objectForKey:type] : type;
}

- (NSString *)description {
  NSMutableString *str = [[NSMutableString alloc] init];
  NSString *namedType = [ADNChannel nameForType:self.type];
  SEL selector = NSSelectorFromString([namedType lowercaseString]);
  if ([self respondsToSelector:selector]) {
    NSString *content = [self performSelector:selector];
    [str appendString:content];
  } else {
    [str appendFormat:@"Type: %@", namedType];
    [str appendFormat:@"\nOwner: %@", (self.owner == nil ? @"[RETIRED OWNER]" : [self.owner shortDescription])];
    [str appendFormat:@"\nID: %ld", self.channelID];
    for (ADNAnnotation *annotation in self.annotations) {
      [str appendFormat:@"\n%@", [annotation description]];
    }
  }
  [str appendString:@"\n----------"];
  return str;
}

- (NSString *)patter {
  NSMutableString *str = [[NSMutableString alloc] init];
  NSString *name = nil;
  NSString *blurb = nil;
  for (ADNAnnotation *annotation in self.annotations) {
    NSDictionary *dictionary = annotation.value;
    if ([dictionary.allKeys containsObject:@"blurb"]) {
      name = [dictionary objectForKey:@"name"];
      blurb = [dictionary objectForKey:@"blurb"];
      break;
    }
  }
  [str appendFormat:@"%@ Patter Room (%ld)", name == nil ? @"Unknown" : name, self.channelID];
  if (blurb != nil) {
    [str appendFormat:@"\n%@", blurb];
  }
  return str;
}

- (NSString *)private {
  NSMutableString *str = [[NSMutableString alloc] init];
  [str appendFormat:@"Private Channel (%ld)", self.channelID];
  [str appendFormat:@"\nUsers: %ld", self.owner.userID];
  for (NSNumber *userID in self.writers.userIDs) {
    [str appendFormat:@", %@", userID];
  }
  return str;
}

@end
