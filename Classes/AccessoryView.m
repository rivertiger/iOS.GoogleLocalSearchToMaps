//
//  AccessoryView.m
//  WebViewTutorial
//
//  Created by USER 1 on 9/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AccessoryView.h"


@implementation AccessoryView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor yellowColor];
		
		//IntroView Edition Label
		UILabel *introHeaderEdition = [[UILabel alloc] initWithFrame:CGRectMake(30.0f, 30.0f, 100.0f, 100.0f)];
		introHeaderEdition.backgroundColor = [UIColor redColor];
		introHeaderEdition.text = @"callout Accesssory";
		introHeaderEdition.textAlignment = UITextAlignmentCenter;
		//introHeaderEdition.font = [UIFont fontWithName:kIntroViewHeaderFont size:kIntroViewHeaderFontSize];
		//introHeaderEdition.textColor = kIntroViewHeaderTextColor;
		[self addSubview:introHeaderEdition];
		[introHeaderEdition release];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
