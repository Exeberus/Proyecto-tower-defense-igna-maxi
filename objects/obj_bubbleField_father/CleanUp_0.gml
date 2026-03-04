if (part_system_exists(shieldHit_sys)) {
    part_type_destroy(part_auraHitted);
    part_system_destroy(shieldHit_sys);
}

if (instance_exists(creator) && creator.myShield != undefined) {
    creator.myShield.myBubble = noone;
    creator.myShield.bubbleIsActive = false;
}