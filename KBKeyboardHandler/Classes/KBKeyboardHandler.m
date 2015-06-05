//
//  KBKeyboardHandler.m
//  KBKeyboardHandler
//
//  Created by Alex Manarpies on 26/09/13.
//
//  Courtesy of Vladimir Grigorov
//  See http://stackoverflow.com/a/12402817/331283

#import "KBKeyboardHandler.h"
#import "KBKeyboardHandlerDelegate.h"

typedef NS_ENUM(NSInteger, KBKeyboardEventType) {
    KBKeyboardEventTypeWill,
    KBKeyboardEventTypeDid
};

@interface KBKeyboardHandler() {
    KBKeyboardEventType eventType;
    CGSize oldDelta;
}

@end

@implementation KBKeyboardHandler

- (id)init
{
    self = [super init];
    if (self)
    {
        // Register for the "didShow" events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        
        // Register for the "willShow" events
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@synthesize delegate;
@synthesize frame;

- (void)keyboardWillShow:(NSNotification *)notification
{
    eventType = KBKeyboardEventTypeWill;
    CGRect oldFrame = self.frame;
    [self retrieveFrameFromNotification:notification];
    
    if (oldFrame.size.height != self.frame.size.height)
    {
        CGSize delta = CGSizeMake(self.frame.size.width - oldFrame.size.width,
                                  self.frame.size.height - oldFrame.size.height);
        if (self.delegate) {
            oldDelta = delta;
            [self notifySizeChanged:delta notification:notification];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    eventType = KBKeyboardEventTypeWill;
    if (self.frame.size.height > 0.0)
    {
        [self retrieveFrameFromNotification:notification];
        CGSize delta = CGSizeMake(-self.frame.size.width, -self.frame.size.height);
        
        if (self.delegate) {
            oldDelta = delta;
            [self notifySizeChanged:delta notification:notification];
        }
    }
    
    self.frame = CGRectZero;
}

- (void)keyboardDidShow:(NSNotification*)notification {
    eventType = KBKeyboardEventTypeDid;
    
    if (self.delegate) {
        [self notifySizeChanged:oldDelta notification:notification];
    }
}

- (void)keyboardDidHide:(NSNotification*)notification {
    eventType = KBKeyboardEventTypeDid;
    
    if (self.delegate) {
        [self notifySizeChanged:oldDelta notification:notification];
    }
}

- (void)retrieveFrameFromNotification:(NSNotification *)notification
{
    CGRect keyboardRect;
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardRect];
    self.frame = [[UIApplication sharedApplication].keyWindow.rootViewController.view convertRect:keyboardRect fromView:nil];
}

- (void)notifySizeChanged:(CGSize)delta notification:(NSNotification *)notification
{
    assert(self.delegate);
    
    NSDictionary *info = [notification userInfo];
    
    UIViewAnimationCurve curve;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    
    NSTimeInterval duration;
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    if (eventType == KBKeyboardEventTypeWill) {
        [self.delegate keyboardSizeWillChange:delta];
    }
    else if (eventType == KBKeyboardEventTypeDid) {
        [self.delegate keyboardSizeDidChange:delta];
    }
    
    [UIView commitAnimations];
}

@end
