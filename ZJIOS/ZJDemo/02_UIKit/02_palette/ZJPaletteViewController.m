//
//  ZJPaletteViewController.m
//  Palette
//
//  Created by YunTu on 15/2/2.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJPaletteViewController.h"
#import "UIViewExt.h"

@interface ZJPaletteViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;

@property (weak, nonatomic) IBOutlet UITextField *valueTF;
@property (weak, nonatomic) IBOutlet UIButton *showPickerViewBtn;
@property (strong, nonatomic)  UIPickerView *colorTypePicker;

@property (nonatomic, strong) NSMutableArray *selectedTypes, *values;

@property (nonatomic, assign) CGRect startFrame, endFrame;
@property (nonatomic, assign) NSInteger row;

@end

@implementation ZJPaletteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedTypes = [NSMutableArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Alpha", nil];
    self.values = [NSMutableArray arrayWithObjects:@0.0, @0.0, @0.0, @1.0, nil];
    self.row = 0;
    
    self.valueTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    for (UISlider *slider in self.sliders) {
        [slider setThumbImage:[UIImage imageNamed:@"playing_slider_thumb"] forState:UIControlStateNormal];
    }
    self.colorView.layer.cornerRadius = 10.0;
    self.colorView.layer.masksToBounds = YES;
    self.colorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    self.startFrame = CGRectMake(self.colorView.left,
                                 self.view.bottom,
                                 self.colorView.width,
                                 self.colorView.height);
    
    self.endFrame = CGRectMake(self.colorView.left,
                               self.colorView.bottom - 70,
                               self.colorView.width,
                               self.colorView.height);
    
    self.colorTypePicker = [[UIPickerView alloc] initWithFrame:self.startFrame];
    self.colorTypePicker.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0];
    self.colorTypePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth; //没反应啊
    self.colorTypePicker.layer.cornerRadius = 10.0;
    self.colorTypePicker.layer.masksToBounds = YES;
    self.colorTypePicker.hidden = YES;
    self.colorTypePicker.delegate = self;
    self.colorTypePicker.dataSource = self;
    [self.view addSubview:self.colorTypePicker];
}

- (IBAction)generateColor:(UISlider *)sender {
    CGFloat value = sender.value;
    
    [self refreshUIValue:sender.tag withObj:[NSNumber numberWithFloat:value]];
}

- (void)refreshUIValue:(NSInteger)index withObj:(id)obj {
    UILabel *label = self.labels[index];
    label.text = [NSString stringWithFormat:@"%.5f", [obj floatValue]];
    [self.values replaceObjectAtIndex:index withObject:obj];
    
    self.colorView.backgroundColor = [UIColor colorWithRed:[self.values[0] floatValue] green:[self.values[1] floatValue] blue:[self.values[2] floatValue] alpha:[self.values[3] floatValue]];
}

- (IBAction)showPickerView:(UIButton *)sender {
    if (self.valueTF.text.length <= 0) return;
    [self hidenTF];
    
    if (self.colorTypePicker.isHidden) {
        self.colorTypePicker.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.colorTypePicker.frame = self.endFrame;
        }];
        [sender setTitle:@"设定" forState:UIControlStateNormal];
    }else {
        [self setColor:self.row withSender:sender];
    }
}

- (BOOL)checkInputValueIsAcceptable:(NSString *)text {
    if (text.length <= 0) {
        return NO;
    }
    
    if (text.floatValue >= 0 && text.floatValue <= 1) {
        return YES;
    }else if(text.floatValue > 1.0){
        self.valueTF.text = @"1.0";
        return YES;
    }else {
        return NO;
    }
}

- (void)setColor:(NSInteger)row withSender:(UIButton *)sender {
    BOOL isAcceptable = [self checkInputValueIsAcceptable:self.valueTF.text];
    if (isAcceptable) {
        [sender setTitle:@"选择设定的颜色类型" forState:UIControlStateNormal];
        
        UISlider *sld = self.sliders[row];
        sld.value = row == 3 ? 1 - self.valueTF.text.floatValue : self.valueTF.text.floatValue;
        
        [self refreshUIValue:row withObj:[NSNumber numberWithFloat:self.valueTF.text.floatValue]];
    }
    
    [self hidenPicker];
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [self hidenTF];
    if (!self.colorTypePicker.isHidden) {
        [self showPickerView:self.showPickerViewBtn];
    }
}

- (void)hidenPicker {
    if(self.colorTypePicker.isHidden == NO ) {
        [UIView animateWithDuration:0.5 animations:^{
            self.colorTypePicker.frame = self.startFrame;
        } completion:^(BOOL finished) {
            self.colorTypePicker.hidden = YES;
        }];
    }
}

- (void)hidenTF {
    if (self.valueTF.isFirstResponder) {
        [self.valueTF resignFirstResponder];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.selectedTypes.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.selectedTypes[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.row = row;
}

#define NUMBERS @"0123456789.\n"

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];//123h5890
    NSLog(@"cs = %@", cs);
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    NSLog(@"filtered = %@, %zd", filtered, filtered.length);
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入数字"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    //其他的类型不需要检测，直接写入
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


