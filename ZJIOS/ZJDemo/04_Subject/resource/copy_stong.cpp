//编译成C++文件,可以看出copy修饰的属性和strong修饰的属性,在底层的处理是不同的
//ViewController对象在底层实则是一个结构体,它的每个属性都将作为该类型结构体的一个成员
struct ViewController_IMPL {
	struct UIViewController_IMPL UIViewController_IVARS;
	NSString *_string_copy;
	NSString *_string_strong;
	NSMutableArray *_array_muta_copy;
	NSMutableArray *_array_muta_strong;
	NSArray *_array_copy;
	NSArray *_array_strong;
};
 
//分别代表_string_copy和_string_strong在ViewController_IMPL结构体中的偏移量,通过偏移量+结构体内存地址就可以找到这个成员
extern "C" unsigned long OBJC_IVAR_$_ViewController$_string_copy;
extern "C" unsigned long OBJC_IVAR_$_ViewController$_string_strong;
 
// self.string_copy = string;
  ((void (*)(id, SEL, NSString *))(void *)objc_msgSend)((id)self, sel_registerName("setString_copy:"), (NSString *)string);
 
// self.string_strong = string;
    ((void (*)(id, SEL, NSString *))(void *)objc_msgSend)((id)self, sel_registerName("setString_strong:"), (NSString *)string);
 
//相当于_string_copy的getter方法,取_string_copy时,返回结构体里的该成员
static NSString * _I_ViewController_string_copy(ViewController * self, SEL _cmd) { return (*(NSString **)((char *)self + OBJC_IVAR_$_ViewController$_string_copy)); }
 
//OC中对copy修饰的属性所做的处理,这个方法下面会有详细说明
extern "C" __declspec(dllimport) void objc_setProperty (id, SEL, long, id, bool, bool);
 
//相当于_string_copy的setter方法,可以看见,内部是调用了objc_setProperty方法做特殊处理的
static void _I_ViewController_setString_copy_(ViewController * self, SEL _cmd, NSString *string_copy) { objc_setProperty (self, _cmd, __OFFSETOFIVAR__(struct ViewController, _string_copy), (id)string_copy, 0, 1); }
 
//_string_strong的getter方法
static NSString * _I_ViewController_string_strong(ViewController * self, SEL _cmd) { return (*(NSString **)((char *)self + OBJC_IVAR_$_ViewController$_string_strong)); }
 
//_string_strong的setter方法,可以明显看到和copy修饰的属性处理不一样,没有调用objc_setProperty方法
static void _I_ViewController_setString_strong_(ViewController * self, SEL _cmd, NSString *string_strong) { (*(NSString **)((char *)self + OBJC_IVAR_$_ViewController$_string_strong)) = string_strong; }
