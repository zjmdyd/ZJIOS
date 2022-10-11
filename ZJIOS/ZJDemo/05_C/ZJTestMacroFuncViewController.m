//
//  ZJTestMacroFuncViewController.m
//  ZJIOS
//
//  Created by issuser on 2022/6/22.
//

#import "ZJTestMacroFuncViewController.h"

@interface ZJTestMacroFuncViewController ()

@end

#define RECORD_TIME(NAME) double _##NAME = [NSDate date].timeIntervalSince1970;

#define TTF_STRINGIZE(x) #x
#define TTF_STRINGIZE2(x) TTF_STRINGIZE(x)
#define TTF_SHADER_STRING(text) @ TTF_STRINGIZE2(text)

static NSString *const CAMREA_RESIZE_VERTEX = TTF_SHADER_STRING
(
attribute vec4 position;
attribute vec4 inputTextureCoordinate;
varying vec2 textureCoordinate;
void main(){
    textureCoordinate = inputTextureCoordinate.xy;
    gl_Position = position;
}
);

@implementation ZJTestMacroFuncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RECORD_TIME(began);
    NSLog(@"_began = %f", _began);
    
    NSString *str = CAMREA_RESIZE_VERTEX;
    NSLog(@"str = %@", str);
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
