//
//  Reel.h
//  Content
//
//  Created by Christopher Miller on 7/19/15.
//  Copyright (c) 2015 The MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DataStoreAdvanced/Model.h>

@interface Reel : Model

@property (nonatomic, strong) NSString * Directors;
@property (nonatomic, strong) NSString * Name;
@property (nonatomic, strong) NSString * ReelPlot;

@end
