//
//  main.m
//  Pre-Populate
//
//  Created by Christopher Miller on 29/05/16.
//  Copyright © 2016 Christopher Miller. All rights reserved.
//

#import "Reel.h"
#import <DataStoreAdvanced/DataStoreHelper.h>
#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSError* err = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [@"ReelExampleDB" stringByAppendingPathExtension:@"sqlite"];
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Reels" ofType:@"json"];
        
        
        // SET UP JSON DATA
        NSArray* Reels = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                         options:kNilOptions
                                                           error:&err];
        
        //DELETE PREVIOUS DATABASE
        BOOL success = [fileManager removeItemAtPath:path error:nil];
        NSLog(@"Success ([fileManager removeItemAtPath:%@ error:nil]): %@", path, success ? @"YES" : @"NO");
        
        // SET UP DATABASE
        NSArray* tables = @[ [Reel class] ];
        [DataStoreHelper setup:@"ReelExampleDB.sqlite" with:tables];
        
        // READ Reel Objects
        [Reels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            Reel *reelInfo = [Reel new];
            
            reelInfo.Name = [obj objectForKey:@"Name"];
            reelInfo.Directors = [obj objectForKey:@"Directors"];
            reelInfo.ReelPlot = [obj objectForKey:@"ReelPlot"];
            
            [reelInfo save];
        }];
        
        // DISPLAY ALL REELS SAVED
        NSArray *fetchedObjects = [Reel all];
        for (Reel *info in fetchedObjects) {
            NSLog(@"Name: %@ Directors: %@", info.Name, info.Directors);
        }
        
        int count = (int) fetchedObjects.count;
        BOOL fetchedSuccess = count == 2;
        NSLog(@"Success (fetchedObjects.count == 15): %@, Actual (%i) ", fetchedSuccess ? @"YES" : @"NO", count);
        
        // COPY SQLITE DB TO Example Project
        //        NSURL *source = [NSURL fileURLWithPath:path];
        //        NSURL *destination = [NSURL fileURLWithPath:path];
        //        NSURL* destination = @"";
        //
        //        if ( [[NSFileManager defaultManager] isReadableFileAtPath:source] ) {
        //            [[NSFileManager defaultManager] copyItemAtURL:source toURL:destination error:&err];
        //        }
    }
    return 0;
}
