// -*- mode: ObjC -*-

//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2011 Steve Nygard.

#import "CDLCSubLibrary.h"

@implementation CDLCSubLibrary

- (id)initWithDataCursor:(CDMachOFileDataCursor *)cursor;
{
    NSUInteger length;

    if ([super initWithDataCursor:cursor] == nil)
        return nil;

    command.cmd = [cursor readInt32];
    command.cmdsize = [cursor readInt32];

    length = command.cmdsize - sizeof(command);
    //NSLog(@"expected length: %u", length);

    name = [[cursor readStringOfLength:length encoding:NSASCIIStringEncoding] retain];
    //NSLog(@"name: %@", name);

    return self;
}

- (void)dealloc;
{
    [name release];

    [super dealloc];
}

- (uint32_t)cmd;
{
    return command.cmd;
}

- (uint32_t)cmdsize;
{
    return command.cmdsize;
}

- (NSString *)name;
{
    return name;
}

@end
