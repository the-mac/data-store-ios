//
//  main.m
//  Populate
//
//  Created by Christopher Miller on 31/05/16.
//
//

#import <Foundation/Foundation.h>
#import <OSXDataStore/OSXDataStore.h>

@interface Reel : Model

@property (nonatomic, strong) NSString * Directors;
@property (nonatomic, strong) NSString * Name;
@property (nonatomic, strong) NSString * ReelPlot;

@end

@implementation Reel
@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSError* err = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *file = [@"ReelExampleDB" stringByAppendingPathExtension:@"sqlite"];
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"Reels" ofType:@"json"];
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dbPath = [directory stringByAppendingPathComponent:file];
        
        // SET UP JSON DATA
        NSArray* Reels = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                         options:kNilOptions
                                                           error:&err];
        
        //DELETE PREVIOUS DATABASE
        BOOL success = [fileManager removeItemAtPath:dbPath error:nil];
        NSLog(@"Success ([fileManager removeItemAtPath:%@ error:nil]): %@", dbPath, success ? @"YES" : @"NO");
        
        // SET UP DATABASE
        NSArray* tables = @[ [Reel classType] ];
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
        
        int expected = 2;
        int count = (int) fetchedObjects.count;
        BOOL fetchedSuccess = count == expected;
        NSLog(@"Success (fetchedObjects.count == %d): %@, Actual (%i) ", expected, fetchedSuccess ? @"YES" : @"NO", count);
        
        // COPY SQLITE DB TO Example Project
        NSString* desktopPath = [NSString stringWithFormat: @"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"], file];
        
        success = [fileManager removeItemAtPath:desktopPath error:nil];
        NSLog(@"Success ([fileManager removeItemAtPath:%@ error:nil]): %@", desktopPath, success ? @"YES" : @"NO");
        
        if ([fileManager fileExistsAtPath:dbPath])
            [fileManager copyItemAtPath:dbPath toPath:desktopPath error:&err];
        
        BOOL exists = [fileManager isReadableFileAtPath:desktopPath];
        NSLog(@"%@ exists %@, error: %@", desktopPath, exists ? @"YES" : @"NO", err);
    }
    return 0;
}
