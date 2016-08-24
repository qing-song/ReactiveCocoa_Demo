//
//  PlayerViewModel.h
//  ReactiveCocoaDemo
//
//  Created by qingsong on 16/8/18.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerViewModel : NSObject

@property(nonatomic, retain) NSString *playerName;

@property(nonatomic, assign) double points;
@property(nonatomic, assign) double stepAmount;
@property(nonatomic, assign) double maxPoints;
@property(nonatomic, assign) double minPoints;

@property(nonatomic, readonly) NSUInteger maxPointUpdates;

-(void)resetToDefaults:(id)sender;

-(void)uploadData:(id)sender;

-(RACSignal *)forbiddenNameSignal;

-(RACSignal *)modelIsValidSignal;


@end
