//
//  GLView.h
//  OpenGL Application
//
//  Created by Alex Nichol on 6/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <GLUT/glut.h>
#import "MeBoxCamera.h"

#define kAnimMultFactor 1

@interface GLView : NSOpenGLView {
	NSTimer * animationTimer;
	anCamera camera;
	anCameraAnimation animation;
	float animationInterval;
	float rota;
	BOOL started;
}
- (void)startAnimation;
- (void)stopAnimation;

- (void)setAnimationInterval:(float)i;
- (float)animationInterval;
@end
