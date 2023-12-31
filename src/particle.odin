package main
import "core:math"
import fmt "core:fmt"
import rl "vendor:raylib"

Particle :: struct {
    pos, vel: rl.Vector2,
    color: rl.Color,
    // float getDist(Vector2 pos);
    // Vector2 getNormal(Vector2 otherPos);
    // void attract(Vector2 pos_to_attract, float multiplier);
    // void doFriction(float amount);
    // void move(int screen_width, int screen_height);
    // void drawPixel();
};


@private
particle_make_from_screen :: proc(screen_width, screen_height : i32) -> Particle {
    self := Particle{}
    self.pos.x = cast(f32) rl.GetRandomValue(0, screen_width-1);
    self.pos.y = cast(f32) rl.GetRandomValue(0, screen_height-1);
    self.vel.x = cast(f32) rl.GetRandomValue(-100, 100) / 100;
    self.vel.y = cast(f32) rl.GetRandomValue(-100, 100) / 100;
    fmt.printf("self.pos %v\n", self.pos)
    // color = (Color){GetRandomValue(0,255),GetRandomValue(0,255),GetRandomValue(0,255),255};
    self.color = rl.Color{0,0,100,100};
    return self
}

@private
particle_make_from_vectors :: proc(pos, vel: rl.Vector2, color: rl.Color = rl.RED) -> Particle {
    self := Particle{}
    self.pos = pos
    self.vel = vel
    self.color = color
    return self
}

particle_make :: proc{particle_make_from_vectors, particle_make_from_screen}


particle_distance :: proc(using self: ^Particle, other_pos: rl.Vector2) -> f32 {
    dx := pos.x - other_pos.x;
    dy := pos.y - other_pos.y;
    return math.sqrt((dx*dx) + (dy*dy));
}

particle_normal :: proc(using self: ^Particle, other_pos: rl.Vector2) -> rl.Vector2 {
    dist := particle_distance(self, other_pos);
    if dist == 0.0 do dist = 1;
    dx := pos.x - other_pos.x;
    dy := pos.y - other_pos.y;
    normal := (rl.Vector2){dx*(1/dist), dy*(1/dist)};
    return normal;
}


particle_attract :: proc(using self: ^Particle, pos_to_attract: rl.Vector2, multiplier:= 1.0) {
    dist := particle_distance(self, pos_to_attract)
    dist = dist if dist > 0.5 else 0.5
    normal := particle_normal(self, pos_to_attract);

    vel.x -= normal.x/dist;
    vel.y -= normal.y/dist;
}

particle_do_friction::proc(using self: ^Particle, amount :f32= 0.97) {
    vel.x *= amount;
    vel.y *= amount;
}

particle_move :: proc(using self: ^Particle, screen_width, screen_height: int) {
    self.pos.x += vel.x;
    self.pos.y += vel.y;
    screen_width, screen_height :f32 =  auto_cast screen_width, auto_cast screen_height
    if (self.pos.x < 0) do self.pos.x += screen_width;
    if (self.pos.x >= screen_width) do self.pos.x -= screen_width;
    if (self.pos.y < 0) do self.pos.y += screen_height;
    if (self.pos.y >= screen_height) do self.pos.y -= screen_height;
}

particle_draw_pixel::proc(using self: ^Particle) {
    rl.DrawPixelV(self.pos, self.color);
    // rl.DrawCircleV(pos, 0.1, rl.RED);
}

