//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNLineChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"

NSInteger const kChartMargin = 10;
NSInteger const kXLabelMargin = 15;
NSInteger const kYLabelMargin = 15;
NSInteger const kYLabelHeight = 11;

@interface PNLineChart()

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;
@property (nonatomic) NSArray *yValues;
@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) int yValueMax;
@property (nonatomic) CAShapeLayer *chartLine;

@end

@implementation PNLineChart

#pragma mark - Properties

@synthesize xLabels = _xLabels;
@synthesize yLabels = _yLabels;
@synthesize yValues = _yValues;
@synthesize yValueMax = _yValueMax;
@synthesize chartLine = _chartLine;
@synthesize strokeColor = _strokeColor;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}

#pragma mark - Start setup chart

- (void)drawLineChartWithxLabels:(NSArray *)xLabels
                         yValues:(NSArray *)yValues
{
//    X
    [self setXLabels:xLabels];
    [self setupXLabel];
    
//    Y
    [self setYValues:yValues];
    [self setYLabels:self.yValues];
    [self setupYLabel];
    
    [self setNeedsDisplay];
}

#pragma mark - Setup UI

- (void)setupXLabel
{
    int nbXLabel = [self.xLabels count];
    self.xLabelWidth = (self.frame.size.width - kChartMargin - 30.0 - (nbXLabel - 1) * kXLabelMargin) / nbXLabel;
    
    for (NSString *labelText in self.xLabels) {
        NSInteger i = [self.xLabels indexOfObject:labelText];
        PNChartLabel *label = [[PNChartLabel alloc]
                               initWithFrame:CGRectMake(i * (kXLabelMargin + self.xLabelWidth) + 30.0,
                                                        self.frame.size.height - 30.0,
                                                        self.xLabelWidth,
                                                        20.0)];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = labelText;
        [self addSubview:label];
    }
}

- (void)setupYLabel
{
    self.yValueMax = 0;
    for (NSString *valueString in self.yLabels) {
        int value = [valueString intValue];
        if (value > self.yValueMax) { self.yValueMax = value; }
    }
    
//    min value for Y label
    if (self.yValueMax < 5) { self.yValueMax = 5; }
    
    float level = self.yValueMax / [self.yValues count];
	
    int index = 0;
	int num = [self.yLabels count] + 1;
	while (num > 0) {
		CGFloat chartCavanHeight = self.frame.size.height - kChartMargin * 2 - 40.0;
		CGFloat levelHeight = chartCavanHeight / 5.0;
		PNChartLabel *label = [[PNChartLabel alloc]
                               initWithFrame:CGRectMake(0.0,
                                                        chartCavanHeight - index * levelHeight + (levelHeight - kYLabelHeight),
                                                        20.0,
                                                        kYLabelHeight)];
		[label setTextAlignment:NSTextAlignmentRight];
		label.text = [NSString stringWithFormat:@"%1.f", level * index];
		
        [self addSubview:label];
        
        index += 1;
		num -= 1;
	}
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    self.chartLine = [CAShapeLayer layer];
    self.chartLine.lineCap = kCALineCapRound;
    self.chartLine.lineJoin = kCALineJoinBevel;
    self.chartLine.fillColor = [[UIColor whiteColor] CGColor];
    self.chartLine.lineWidth = 3.0;
    self.chartLine.strokeEnd = 0.0;
    if (self.strokeColor) {
        self.chartLine.strokeColor = [self.strokeColor CGColor];
    } else {
        self.chartLine.strokeColor = [PNGreen CGColor];
    }
    
    [self.layer addSublayer:self.chartLine];

    if ([self.yValues count] > 0) {
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[self.yValues objectAtIndex:0] floatValue];
        CGFloat xPosition = (kXLabelMargin + self.xLabelWidth);
        CGFloat chartCavanHeight = self.frame.size.height - kChartMargin * 2 - 40.0;
        
        float grade = (float)firstValue / (float)self.yValueMax;
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight + 20.0)];
        [progressline setLineWidth:3.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        int index = 0;
        for (NSString *valueString in self.yValues) {
            int value = [valueString intValue];
            float grade = (float)value / (float)self.yValueMax;
            
            if (index != 0) {
                [progressline addLineToPoint:CGPointMake(index * xPosition + 30.0 + self.xLabelWidth / 2.0,
                                                         chartCavanHeight - grade * chartCavanHeight + 20.0)];
                [progressline moveToPoint:CGPointMake(index * xPosition + 30.0 + self.xLabelWidth / 2.0,
                                                      chartCavanHeight - grade * chartCavanHeight + 20.0 )];
                [progressline stroke];
            }
            
            index += 1;
        }
        
        self.chartLine.path = progressline.CGPath;
        
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 1.0;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [self.chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        self.chartLine.strokeEnd = 1.0;
    }
}

@end
