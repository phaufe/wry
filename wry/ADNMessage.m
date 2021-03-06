//
//  ADNMessage.m
//  wry
//
//  Created by Rob Warner on 05/06/13.
//  Copyright (c) 2013 Rob Warner. All rights reserved.
//

#import "ADNMessage.h"
#import "ADNUser.h"

@implementation ADNMessage

- (NSString *)description {
  NSMutableString *str = [[NSMutableString alloc] init];
  [str appendString:(self.user == nil ? @"[RETIRED USER]" : [self.user shortDescription])];
  [str appendFormat:@"\nChannel ID: %ld", self.channelID];
  [str appendFormat:@"\n%@", (self.text == nil ? @"[REDACTED]" : self.text)];
  [str appendFormat:@"\nID: %ld -- %@", self.messageID, self.createdAt];
  [str appendString:@"\n----------"];
  return str;
}

@end
