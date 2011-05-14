/*
 *  MeBoxCamera.h
 *  MeBox
 *
 *  Created by Alex Nichol on 5/13/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <stdlib.h>
#import <math.h>

typedef struct {
	float x;
	float y;
	float z;
} vector3d;

typedef vector3d point3d;

typedef struct {
	point3d location;
	vector3d rotation;
	vector3d lookRotation;
} anCamera;

typedef struct {
	int delay;
	int incrCount;
	point3d destLocation;
	vector3d destRotation;
	vector3d destLookRotation;
	vector3d locationMovement;
	vector3d rotationMovement;
	vector3d lookRotationMovement;
} anCameraAnimation;

point3d point3dMake (float x, float y, float z);
vector3d vector3dMake (float x, float y, float z);

anCameraAnimation createIDAnimation();

/*
 * Takes an animation, and a camera.  Applies the animation to the
 * specified camera.
 * @param animation The animation that will be applied.  This will be
 * set to the identity animation if the animation is complete.
 * @param camera The camera to which we will apply the animation.
 * @return The status of the animation.  This is 0 on a successful animation,
 * or 1 when the animation is completed.
 */
int applyCameraAnimationToCamera (anCameraAnimation * animation, anCamera * camera);
