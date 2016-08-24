//
//  ControlViewController.m
//  ReactiveCocoaDemo
//
//  Created by qingsong on 16/8/18.
//  Copyright © 2016年 qingsong. All rights reserved.
//

#import "ControlViewController.h"
#import "PlayerViewModel.h"

@interface ControlViewController ()

@property(nonatomic,strong) PlayerViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIStepper *scoreStepper;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property(nonatomic,assign) NSUInteger scoreUpdates;

@end

static NSInteger const kMaxUploads = 5;

@implementation ControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.viewModel = [PlayerViewModel new];

    @weakify(self);
    
    RAC(self.nameField, text) = [RACObserve(self.viewModel, playerName) distinctUntilChanged];
    
    [[self.nameField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
       
        @strongify(self);
        self.viewModel.playerName = (NSString *)x;
        
        NSLog(@"x   %@",x);
    }];
    
    
    RAC(self.scoreLabel,text) = [RACObserve(self.viewModel,points) map:^id(NSNumber *value) {
       
        return [value stringValue];
    }];
    
    self.scoreStepper.value = self.viewModel.points;
    
    RAC(self.scoreStepper, stepValue) = RACObserve(self.viewModel, stepAmount);
    RAC(self.scoreStepper,maximumValue) = RACObserve(self.viewModel,maxPoints);
    RAC(self.scoreStepper,minimumValue) = RACObserve(self.viewModel,minPoints);
    
    // 判断scoreStepper 达到最大值后，隐藏
    RAC(self.scoreStepper, hidden) = [RACObserve(self, scoreUpdates) map:^id(NSNumber *value) {
        @strongify(self);
        return @(value.intValue >= self.viewModel.maxPointUpdates);
    }];

    
    [[[RACObserve(self.scoreStepper, value) skip:1] take:self.viewModel.maxPointUpdates] subscribeNext:^(id x) {
        @strongify(self);
        self.viewModel.points = [x doubleValue];
        self.scoreUpdates++;
    }];
    
    [self.viewModel.forbiddenNameSignal subscribeNext:^(NSString * name) {
       
        @strongify(self);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forbidden Name!"
                                                        message:[NSString stringWithFormat:@"The name %@ has been forbidden!",name]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        self.viewModel.playerName = @"";
        
    }];
    
    RAC(self.uploadButton,enabled) = self.viewModel.modelIsValidSignal;
    
    [self.uploadButton addTarget:self.viewModel
                          action:@selector(uploadData:)
                forControlEvents:UIControlEventTouchUpInside];
    
    // 更新按钮，最多点击5次，的RAC
    [[[[self.uploadButton rac_signalForControlEvents:UIControlEventTouchUpInside] skip:(kMaxUploads-1)] take:1] subscribeNext:^(id x) {
        
        @strongify(self);
        self.nameField.enabled = NO;
        self.scoreStepper.hidden = YES;
        self.uploadButton.hidden = YES;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
