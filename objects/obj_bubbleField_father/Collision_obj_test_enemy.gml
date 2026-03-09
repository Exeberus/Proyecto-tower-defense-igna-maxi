if (bubbleClass != noone && bubbleClass.state == BUBBLE_STATE.ACTIVE) {
    bubbleClass.emitFilterWarning(other.x, other.y);
}