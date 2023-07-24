#if __has_include(<RCTText/RCTTextSelection.h>)
#import <RCTText/RCTTextSelection.h>
#else
#import "RCTTextSelection.h"
#endif

#if __has_include(<RCTText/RCTUITextView.h>)
#import <RCTText/RCTUITextView.h>
#else
#import "RCTUITextView.h"
#endif

#import "RNSelectableTextView.h"

#if __has_include(<RCTText/RCTTextAttributes.h>)
#import <RCTText/RCTTextAttributes.h>
#else
#import "RCTTextAttributes.h"
#endif

#import <React/RCTUtils.h>

@implementation RNSelectableTextView
{
    RCTUITextView *_backedTextInputView;
}

NSString *const RNST_CUSTOM_SELECTOR = @"_CUSTOM_SELECTOR_";

UITextPosition *selectionStart;
UITextPosition* beginning;

- (instancetype)initWithBridge:(RCTBridge *)bridge
{
    if (self = [super initWithBridge:bridge]) {
        // `blurOnSubmit` defaults to `false` for <TextInput multiline={true}> by design.
        // self.blurOnSubmit = NO;
        
        _backedTextInputView = [[RCTUITextView alloc] initWithFrame:self.bounds];
        _backedTextInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backedTextInputView.backgroundColor = [UIColor clearColor];
        _backedTextInputView.textColor = [UIColor blackColor];
        // This line actually removes 5pt (default value) left and right padding in UITextView.
        _backedTextInputView.textContainer.lineFragmentPadding = 0;
#if !TARGET_OS_TV
        _backedTextInputView.scrollsToTop = NO;
#endif
        _backedTextInputView.scrollEnabled = NO;
        _backedTextInputView.textInputDelegate = self;
        _backedTextInputView.editable = NO;
        _backedTextInputView.selectable = YES;
        _backedTextInputView.contextMenuHidden = YES;
        
        beginning = _backedTextInputView.beginningOfDocument;
        
        [self addSubview:_backedTextInputView];
        
        UITapGestureRecognizer *singleTapGesture = [ [UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapGesture.numberOfTapsRequired = 1;
        
        [_backedTextInputView addGestureRecognizer:singleTapGesture];
        
        [self setUserInteractionEnabled:YES];
        
    }
    
    return self;
}

// call calculateRectsForHighlights when the view is added to the view hierarchy
- (void) didMoveToWindow {
    [super didMoveToWindow];
    
    // after 300ms, calculate the rects for the highlights
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        [self calculateRectsForHighlights];
    });
}

- (void) calculateRectsForHighlights {
    if (self.highlights) {
        NSMutableArray *rects = [[NSMutableArray alloc] init];
        
        for (NSDictionary *highlight in self.highlights) {
            NSInteger start = [highlight[@"start"] integerValue];
            NSInteger end = [highlight[@"end"] integerValue];
            
            UITextPosition *startPosition = [_backedTextInputView positionFromPosition:beginning offset:start];
            UITextPosition *endPosition = [_backedTextInputView positionFromPosition:beginning offset:end];
            
            UITextRange *textRange = [_backedTextInputView textRangeFromPosition:startPosition toPosition:endPosition];
            
            CGRect selectionRect = [_backedTextInputView firstRectForRange:textRange];
            
            if (selectionRect.origin.x == INFINITY || selectionRect.origin.y == INFINITY || selectionRect.size.width == INFINITY || selectionRect.size.height == INFINITY) {
                // it means that the selection is collapsed, continue without adding it
                continue;
            } else {
                [rects addObject:@{
                    @"id": highlight[@"id"],
                    @"rect": @{
                        @"x": @(selectionRect.origin.x),
                        @"y": @(selectionRect.origin.y),
                        @"width": @(selectionRect.size.width),
                        @"height": @(selectionRect.size.height)
                    }
                }];
            }
        }
        
        self.onHighlightRectsCalculated(@{
            @"rects": rects
        });
    }
}

- (void) textInputDidChangeSelection {
    if (self.onTextSelectionChange) {
        RCTTextSelection *selection = self.selection;
        CGRect selectionRect = [self getSelectionRect];
        
        if (selectionRect.origin.x == INFINITY || selectionRect.origin.y == INFINITY || selectionRect.size.width == INFINITY || selectionRect.size.height == INFINITY) {
            // it means that the selection is collapsed
            self.onTextSelectionChange(@{
                @"selection": @{
                    @"start": @(selection.start),
                    @"end": @(selection.end),
                    @"rect": @{
                        @"x": @(0),
                        @"y": @(0),
                        @"width": @(0),
                        @"height": @(0)
                    }
                }
            });
        } else {
            self.onTextSelectionChange(@{
                @"selection": @{
                    @"start": @(selection.start),
                    @"end": @(selection.end),
                    @"rect": @{
                        @"x": @(selectionRect.origin.x),
                        @"y": @(selectionRect.origin.y),
                        @"width": @(selectionRect.size.width),
                        @"height": @(selectionRect.size.height)
                    }
                }
            });
        }
    }
}

- (CGRect) getSelectionRect {
    NSArray<UITextSelectionRect *> *selectionRects = [_backedTextInputView selectionRectsForRange:_backedTextInputView.selectedTextRange];
    CGRect completeRect = CGRectNull;
    
    for (UITextSelectionRect *selectionRect in selectionRects) {
        if (CGRectIsNull(completeRect)) {
            completeRect = selectionRect.rect;
        } else {
            completeRect = CGRectUnion(completeRect, selectionRect.rect);
        }
    }
    
    return completeRect;
}

-(void) _handleGesture
{
    if (!_backedTextInputView.isFirstResponder) {
        [_backedTextInputView becomeFirstResponder];
    }
}

-(void) handleSingleTap: (UITapGestureRecognizer *) gesture
{
    CGPoint pos = [gesture locationInView:_backedTextInputView];
    pos.y += _backedTextInputView.contentOffset.y;
    
    UITextPosition *tapPos = [_backedTextInputView closestPositionToPoint:pos];
    UITextRange *word = [_backedTextInputView.tokenizer rangeEnclosingPosition:tapPos withGranularity:(UITextGranularityWord) inDirection:UITextLayoutDirectionRight];
    
    UITextPosition* beginning = _backedTextInputView.beginningOfDocument;
    
    UITextPosition *selectionStart = word.start;
    UITextPosition *selectionEnd = word.end;
    
    const NSInteger startLocation = [_backedTextInputView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger endLocation = [_backedTextInputView offsetFromPosition:beginning toPosition:selectionEnd];
    
    self.onWordPress(@{
        @"clickedRangeStart": @(startLocation),
        @"clickedRangeEnd": @(endLocation),
    });
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    if (self.value) {
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.value attributes:self.textAttributes.effectiveTextAttributes];
        
        [super setAttributedText:str];
    } else {
        [super setAttributedText:attributedText];
    }
}

- (id<RCTBackedTextInputViewProtocol>)backedTextInputView
{
    return _backedTextInputView;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(selectionStart != nil) {return NO;}
    NSString *sel = NSStringFromSelector(action);
    NSRange match = [sel rangeOfString:RNST_CUSTOM_SELECTOR];
    
    if (match.location == 0) {
        return YES;
    }
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!_backedTextInputView.isFirstResponder) {
        [_backedTextInputView setSelectedTextRange:nil notifyDelegate:true];
    } else {
        UIView *sub = nil;
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point toView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            
            if (!result.isFirstResponder) {
                NSString *name = NSStringFromClass([result class]);
                
                if ([name isEqual:@"UITextRangeView"]) {
                    sub = result;
                }
            }
        }
        
        if (sub == nil) {
            [_backedTextInputView setSelectedTextRange:nil notifyDelegate:true];
        }
    }
    
    return [super hitTest:point withEvent:event];
}

@end
