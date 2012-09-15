// -*- mode: ObjC -*-

//  This file is part of class-dump, a utility for examining the Objective-C segment of Mach-O files.
//  Copyright (C) 1997-1998, 2000-2001, 2004-2012 Steve Nygard.

#import "CDFile.h"

#import "CDFatFile.h"
#import "CDMachOFile.h"
#import "CDSearchPathState.h"

NSString *CDNameForCPUType(cpu_type_t cputype, cpu_subtype_t cpusubtype)
{
    const NXArchInfo *archInfo = NXGetArchInfoFromCpuType(cputype, cpusubtype);
    if (archInfo != NULL)
        return [NSString stringWithUTF8String:archInfo->name];

    // Special cases until the built-in function recognizes these.
    switch (cputype) {
        case CPU_TYPE_ARM: {
            switch (cpusubtype) {
                case 11: return @"armv7s"; // Not recognized in 10.8.0
                default: break;
            }
        }
        default: break;
    }

    return [NSString stringWithFormat:@"0x%x:0x%x", cputype, cpusubtype];
}

CDArch CDArchFromName(NSString *name)
{
    CDArch arch;

    arch.cputype = CPU_TYPE_ANY;
    arch.cpusubtype = 0;

    if (name == nil)
        return arch;

    const NXArchInfo *archInfo = NXGetArchInfoFromName([name UTF8String]);
    if (archInfo == NULL) {
        NSScanner *scanner;
        NSString *ignore;

        scanner = [[NSScanner alloc] initWithString:name];
        if ([scanner scanHexInt:(uint32_t *)&arch.cputype]
            && [scanner scanString:@":" intoString:&ignore]
            && [scanner scanHexInt:(uint32_t *)&arch.cpusubtype]) {
            // Great!
            //NSLog(@"scanned 0x%08x : 0x%08x from '%@'", arch.cputype, arch.cpusubtype, name);
        } else {
            arch.cputype = CPU_TYPE_ANY;
            arch.cpusubtype = 0;
        }
    } else {
        arch.cputype = archInfo->cputype;
        arch.cpusubtype = archInfo->cpusubtype;
    }

    return arch;
}

BOOL CDArchUses64BitABI(CDArch arch)
{
    return (arch.cputype & CPU_ARCH_MASK) == CPU_ARCH_ABI64;
}

#pragma mark -

@implementation CDFile
{
    NSString *_filename;
    NSData *_data;
    NSUInteger _archOffset;
    NSUInteger _archSize;
    CDSearchPathState *_searchPathState;
}

+ (id)fileWithData:(NSData *)data filename:(NSString *)filename searchPathState:(CDSearchPathState *)searchPathState;
{
    return [self fileWithData:data archOffset:0 archSize:[data length] filename:filename searchPathState:searchPathState];
}

+ (id)fileWithData:(NSData *)data archOffset:(NSUInteger)offset archSize:(NSUInteger)size filename:(NSString *)filename searchPathState:(CDSearchPathState *)searchPathState;
{
    CDFatFile *fatFile = nil;

    if (offset == 0)
        fatFile = [[CDFatFile alloc] initWithData:data archOffset:offset archSize:size filename:filename searchPathState:searchPathState];

    if (fatFile == nil) {
        CDMachOFile *machOFile = [[CDMachOFile alloc] initWithData:data archOffset:offset archSize:size filename:filename searchPathState:searchPathState];
        return machOFile;
    }

    return fatFile;
}

- (id)init;
{
    [NSException raise:@"RejectUnusedImplementation" format:@"-initWithData: is the designated initializer"];
    return nil;
}

- (id)initWithData:(NSData *)data archOffset:(NSUInteger)offset archSize:(NSUInteger)size filename:(NSString *)filename searchPathState:(CDSearchPathState *)searchPathState;
{
    if ((self = [super init])) {
        // Otherwise reading the magic number fails.
        if ([data length] < 4) {
            return nil;
        }
        
        _filename = filename;
        _data = data;
        _archOffset = offset;
        _archSize = size;
        _searchPathState = searchPathState;
    }

    return self;
}

#pragma mark -

- (BOOL)bestMatchForLocalArch:(CDArch *)archPtr;
{
    if (archPtr != NULL) {
        archPtr->cputype = CPU_TYPE_ANY;
        archPtr->cpusubtype = 0;
    }

    return YES;
}

- (CDMachOFile *)machOFileWithArch:(CDArch)arch;
{
    return nil;
}

@end
