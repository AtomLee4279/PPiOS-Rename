// -*- mode: ObjC -*-

//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2011 Steve Nygard.

#import "CDLoadCommand.h"
#include <mach-o/loader.h>

@interface CDLCPreboundDylib : CDLoadCommand
{
    struct prebound_dylib_command preboundDylibCommand;
    NSString *name;
}

- (id)initWithDataCursor:(CDMachOFileDataCursor *)cursor;
- (void)dealloc;

- (uint32_t)cmd;
- (uint32_t)cmdsize;

- (NSString *)name;

@end
