//
//  AppDelegate.m
//  Populate
//
//  Created by Christopher Miller on 03/06/16.
//  Copyright © 2016 The MAC. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import <OSXDataStore/OSXDataStore.h>

@interface Flight : Model

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *delayed;
@property (strong, nonatomic) NSString *departing;
@property (strong, nonatomic) NSString *departingAbbr;
@property (strong, nonatomic) NSString *arriving;
@property (strong, nonatomic) NSString *arrivingAbbr;

@end

@implementation Flight
@end


@interface Reel : Model

@property (nonatomic, strong) NSString * Certificate;
@property (nonatomic, strong) NSString * Directors;
@property (nonatomic, strong) NSString * Name;
@property (nonatomic, strong) NSString * NotSure;
@property (nonatomic, strong) NSString * ReelID;
@property (nonatomic, strong) NSString * ReelPlot;
@property (nonatomic, strong) NSString * ReelRating;
@property (nonatomic, strong) NSString * RunTime;
@property (nonatomic, strong) NSString * SubGenre;
@property (nonatomic, strong) NSString * Trailer;
@property (nonatomic, strong) NSString * WatchedBad;
@property (nonatomic, strong) NSString * WatchedGood;
@property (nonatomic, strong) NSString * WatchLater;
@property (nonatomic, strong) NSString * Year;

@end

@implementation Reel
@end

@interface AppDelegate ()

@property (strong, nonatomic) NSArray *models;
@property (assign, nonatomic) NSInteger modelIndex;
@property (weak) IBOutlet NSTextField *tableName;
@property (weak) IBOutlet NSTextField *jsonInputPath;
@property (weak) IBOutlet NSTextField *sqliteOutputPath;
@property (weak) IBOutlet NSTextField *sqliteOutputName;
@property (weak) IBOutlet NSButton *generateButton;
@property (weak) IBOutlet NSButton *skipTableButton;
@end

@implementation AppDelegate
- (NSString*)getDatabaseName {
    return @"FlightsExampleDB";
}
- (NSArray<Model*>*)getTables {
    return @[ [Reel class] ];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"%s was called", __FUNCTION__);
    
    self.models = [self getTables];
    if(self.models.count > 0) {
        
        self.tableName.stringValue = NSStringFromClass(self.models[self.modelIndex]);
        self.generateButton.enabled = [self canCreateTable];
        
        NSString * outputFile = [self getDatabaseName];
        self.sqliteOutputName.stringValue = outputFile;
        
    } else {
        self.tableName.stringValue = @"Missing Model class reference(s)";
    }
    self.skipTableButton.enabled = [self hasTableModels];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)hasTableModels {
    return self.models.count > 1;
}
- (IBAction)skipTable:(id)sender {
    self.modelIndex = ++self.modelIndex % self.models.count;
    self.tableName.stringValue = NSStringFromClass(self.models[self.modelIndex]);
    self.generateButton.enabled = [self canCreateTable];
}
- (IBAction)generate:(id)sender {
    [self processJSONToTable];
}

- (IBAction)open:(NSMenuItem*)sender {

    NSLog(@"%s was called", __FUNCTION__);
    
    __block BOOL isJSONImportPath = sender.tag == 1;
    __block BOOL isSqLiteExportPath = sender.tag == 2;
    __block NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    if(isJSONImportPath) {
        [panel setCanChooseFiles:YES];
        [panel setAllowedFileTypes:[NSArray arrayWithObject:@"json"]];
    }
    else {
        [panel setCanChooseFiles:NO];
        [panel setCanChooseDirectories:YES];
    }
    
    [panel setAllowsMultipleSelection:NO];
    
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            if (isJSONImportPath) {
                NSURL *thePath = [[panel URLs] objectAtIndex:0];
                NSLog(@"%s was called with json file: %@", __FUNCTION__, thePath);
                self.jsonInputPath.stringValue = [thePath path];
            }
            else if (isSqLiteExportPath) {
                NSURL *thePath = [[panel URLs] objectAtIndex:0];
                NSLog(@"%s was called with export path: %@", __FUNCTION__, thePath);
                self.sqliteOutputPath.stringValue = [thePath path];
            }
        }
        self.generateButton.enabled = [self canCreateTable];
    }];
}
- (IBAction)completedName:(id)sender {
    
    NSLog(@"%s was called", __FUNCTION__);
    self.generateButton.enabled = [self canCreateTable];
}

- (BOOL)canCreateTable {
    
    BOOL parametersReady = self.tableName.stringValue != nil;
    if(parametersReady) parametersReady = self.jsonInputPath.stringValue != nil && self.jsonInputPath.stringValue.length > 0;
    if(parametersReady) parametersReady = self.sqliteOutputPath.stringValue != nil && self.sqliteOutputPath.stringValue.length > 0;
    if(parametersReady) parametersReady = self.sqliteOutputName.stringValue != nil && self.sqliteOutputName.stringValue.length > 0;
//    if(parametersReady) parametersReady = [self.sqliteOutputName.stringValue componentsSeparatedByString:@"."].count > 1;
    
    return parametersReady;
}

- (void)processJSONToTable {
    self.generateButton.enabled = NO;
    
    NSError* err = nil;
    NSArray* tables = [self getTables];
    Class classType = tables[self.modelIndex];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *file = [self.sqliteOutputName.stringValue stringByAppendingPathExtension:@"sqlite"];
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbPath = [directory stringByAppendingPathComponent:file];
    
    // SET UP DATABASE
    [NSThread sleepForTimeInterval:1.5];
    
    //DELETE PREVIOUS DATABASE
    BOOL success = [fileManager removeItemAtPath:dbPath error:&err];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    if(err) {
        NSLog(@"Error with dbPath(%@), %@\n", dbPath, err);
        err = nil;
    }
    
    NSLog(@"Success ([fileManager removeItemAtPath:%@ error:nil]): %@\n", dbPath, success ? @"YES" : @"NO");
    
    [DataStoreHelper setup:file with:self.models];
    
    // SET UP JSON DATA
    NSString* dataPath = self.jsonInputPath.stringValue;
    NSArray* objects = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                       options:kNilOptions
                                                         error:&err];
    
    if(err) {
        self.generateButton.enabled = YES;
        NSLog(@"Error with dataPath(%@): %@\n", dataPath, err);
        return;
    }
    
    // READ Model Objects
    [objects enumerateObjectsUsingBlock:^(id objectInfo, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = (NSDictionary*)objectInfo;
        [classType create:[dict mutableCopy]];
    }];
    
    // DISPLAY ALL Model Objects SAVED
    NSArray *fetchedObjects = [classType all];
    for (Model *info in fetchedObjects) {
        NSLog(@"%@", info);
    }
    
    int expected = 2;
    int count = (int) fetchedObjects.count;
    BOOL fetchedSuccess = count == expected;
    NSLog(@"Success (fetchedObjects.count == %d): %@, Actual (%i)\n", expected, fetchedSuccess ? @"YES" : @"NO", count);
    
    // COPY SQLITE DB TO Example Project
    NSString* outputPath = [NSString stringWithFormat: @"%@/%@", self.sqliteOutputPath.stringValue, file];
    success = [fileManager removeItemAtPath:outputPath error:&err];
    
    if(err) {
        NSLog(@"Error with outputPath(%@): %@\n", outputPath, err);
    }
    
    NSLog(@"Success ([fileManager removeItemAtPath:%@ error:nil]): %@\n", outputPath, success ? @"YES" : @"NO");
    
    if ([fileManager fileExistsAtPath:dbPath])
        [fileManager copyItemAtPath:dbPath toPath:outputPath error:&err];
    
    if(err) {
        self.generateButton.enabled = YES;
        NSLog(@"Error with dbPath(%@) and outputPath(%@): %@\n", dbPath, outputPath, err);
        return;
    }
    
    BOOL exists = [fileManager isReadableFileAtPath:outputPath];
    NSLog(@"%@ exists %@\n", outputPath, exists ? @"YES" : @"NO");
    self.generateButton.enabled = !exists;
}

@end
