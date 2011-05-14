/*
 *  MeBoxCamera.c
 *  MeBox
 *
 *  Created by Alex Nichol on 5/13/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */


#import "MeBoxCamera.h"

#define myAbs(x) (sign(x) * x)

static double sign (double d) {
	if (d < 0) return -1;
	return 1;
}

anCameraAnimation createIDAnimation () {
	anCameraAnimation animation;
	animation.destLocation = point3dMake(0, 0, 0);
	animation.locationMovement = vector3dMake(0, 0, 0);
	animation.rotationMovement = vector3dMake(0, 0, 0);
	animation.destRotation = vector3dMake(0, 0, 0);
	animation.destLookRotation = vector3dMake(0, 0, 0);
	animation.lookRotationMovement = vector3dMake(0, 0, 0);
	animation.delay = 0;
	animation.incrCount = 0;
	return animation;
}

point3d point3dMake (float x, float y, float z) {
	point3d p;
	p.x = x;
	p.y = y;
	p.z = z;
	return p;
}
vector3d vector3dMake (float x, float y, float z) {
	vector3d v;
	v.x = x;
	v.y = y;
	v.z = z;
	return v;
}	

int applyCameraAnimationToCamera (anCameraAnimation * animation, anCamera * camera) {
	int changed = 0;
	if (animation->incrCount++ < animation->delay) {
		return 1;
	}
	// location (camera)
	if (animation->locationMovement.x != 0) {
		if (camera->location.x < animation->destLocation.x) {
			camera->location.x += myAbs(animation->locationMovement.x);
			if (camera->location.x > animation->destLocation.x) {
				camera->location.x = animation->destLocation.x;
			} else changed = 1;
		} else if (camera->location.x > animation->destLocation.x) {
			camera->location.x -= myAbs(animation->locationMovement.x);
			if (camera->location.x < animation->destLocation.x) {
				camera->location.x = animation->destLocation.x;
			} else changed = 1;
		}
	}
	if (animation->locationMovement.y != 0) {
		if (camera->location.y < animation->destLocation.y) {
			camera->location.y += myAbs(animation->locationMovement.y);
			if (camera->location.y > animation->destLocation.y) {
				camera->location.y = animation->destLocation.y;
			} else changed = 1;
		} else if (camera->location.y > animation->destLocation.y) {
			camera->location.y -= myAbs(animation->locationMovement.y);
			if (camera->location.y < animation->destLocation.y) {
				camera->location.y = animation->destLocation.y;
			} else changed = 1;
		}
	}
	if (animation->locationMovement.z != 0) {
		if (camera->location.z < animation->destLocation.z) {
			camera->location.z += myAbs(animation->locationMovement.z);
			if (camera->location.z > animation->destLocation.z) {
				camera->location.z = animation->destLocation.z;
			} else changed = 1;
		} else if (camera->location.z > animation->destLocation.z) {
			camera->location.z -= myAbs(animation->locationMovement.z);
			if (camera->location.z < animation->destLocation.z) {
				camera->location.z = animation->destLocation.z;
			} else changed = 1;
		}
	}
	// rotation (box)
	if (animation->rotationMovement.x != 0) {
		if (camera->rotation.x < animation->destRotation.x) {
			camera->rotation.x += myAbs(animation->rotationMovement.x);
			if (camera->rotation.x > animation->destRotation.x) {
				camera->rotation.x = animation->destRotation.x;
			} else changed = 1;
		} else if (camera->rotation.x > animation->destRotation.x) {
			camera->rotation.x -= myAbs(animation->rotationMovement.x);
			if (camera->rotation.x < animation->destRotation.x) {
				camera->rotation.x = animation->destRotation.x;
			} else changed = 1;
		}
	}
	if (animation->rotationMovement.y != 0) {
		if (camera->rotation.y < animation->destRotation.y) {
			camera->rotation.y += myAbs(animation->rotationMovement.y);
			if (camera->rotation.y > animation->destRotation.y) {
				camera->rotation.y = animation->destRotation.y;
			} else changed = 1;
		} else if (camera->rotation.y > animation->destRotation.y) {
			camera->rotation.y -= myAbs(animation->rotationMovement.y);
			if (camera->rotation.y < animation->destRotation.y) {
				camera->rotation.y = animation->destRotation.y;
			} else changed = 1;
		}
	}
	if (animation->rotationMovement.z != 0) {
		if (camera->rotation.z < animation->destRotation.z) {
			camera->rotation.z += myAbs(animation->rotationMovement.z);
			if (camera->rotation.z > animation->destRotation.z) {
				camera->rotation.z = animation->destRotation.z;
			} else changed = 1;
		} else if (camera->rotation.z > animation->destRotation.z) {
			camera->rotation.z -= myAbs(animation->rotationMovement.z);
			if (camera->rotation.z < animation->destRotation.z) {
				camera->rotation.z = animation->destRotation.z;
			} else changed = 1;
		}
	}
	// rotation (camera)
	if (animation->lookRotationMovement.x != 0) {
		if (camera->lookRotation.x < animation->destLookRotation.x) {
			camera->lookRotation.x += myAbs(animation->lookRotationMovement.x);
			if (camera->lookRotation.x > animation->destLookRotation.x) {
				camera->lookRotation.x = animation->destLookRotation.x;
			} else changed = 1;
		} else if (camera->lookRotation.x > animation->destLookRotation.x) {
			camera->lookRotation.x -= myAbs(animation->lookRotationMovement.x);
			if (camera->lookRotation.x <= animation->destLookRotation.x) {
				camera->lookRotation.x = animation->destLookRotation.x;
			} else changed = 1;
		}
	}
	if (animation->lookRotationMovement.y != 0) {
		if (camera->lookRotation.y < animation->destLookRotation.y) {
			camera->lookRotation.y += myAbs(animation->lookRotationMovement.y);
			if (camera->lookRotation.y > animation->destLookRotation.y) {
				camera->lookRotation.y = animation->destLookRotation.y;
			} else changed = 1;
		} else if (camera->lookRotation.y > animation->destLookRotation.y) {
			camera->lookRotation.y -= myAbs(animation->lookRotationMovement.y);
			if (camera->lookRotation.y < animation->destLookRotation.y) {
				camera->lookRotation.y = animation->destLookRotation.y;
			} else changed = 1;
		}
	}
	if (animation->lookRotationMovement.z != 0) {
		if (camera->lookRotation.z < animation->destLookRotation.z) {
			camera->lookRotation.z += myAbs(animation->lookRotationMovement.z);
			if (camera->lookRotation.z > animation->destLookRotation.z) {
				camera->lookRotation.z = animation->destLookRotation.z;
			} else changed = 1;
		} else if (camera->lookRotation.z > animation->destLookRotation.z) {
			camera->lookRotation.z -= myAbs(animation->lookRotationMovement.z);
			if (camera->lookRotation.z < animation->destLookRotation.z) {
				camera->lookRotation.z = animation->destLookRotation.z;
			} else changed = 1;
		}
	}
	if (changed == 0) {
		*animation = createIDAnimation();
	}
	return changed;
}
