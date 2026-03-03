part_system_destroy(shield_sys);
if (instance_exists(creator)) {
	creator.myBubble = noone;
    creator.bubbleIsActive = false;
    creator.alarm[0] = creator.bubbleRechargeSpeed; 
}