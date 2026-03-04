//Shield Particles
myShield.shieldParticles(id);
myShield.update();
//Bubble
if(instance_exists(myShield.myBubble)){
	myShield.checkAndRecreateBubble(id, obj_stellarite_bubbleField_mk1);
}
myShield.bubblePositionUpdate(id);
