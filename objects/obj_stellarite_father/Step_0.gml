image_angle += rot_speed;
speed += random_range(-0.05, 0.05);
direction += random_range(-2, 2);

direction = clamp(direction, 240, 300);
speed = clamp(speed, 0.5, 3);


