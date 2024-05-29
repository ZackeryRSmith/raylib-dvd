const std = @import("std");
const rl = @import("raylib");
const rlm = @import("raylib-math");

const SCREEN_WIDTH = 800;
const SCREEN_HEIGHT = 450;

pub const Logo = struct {
    var rand = std.rand.DefaultPrng.init(24);

    texture: rl.Texture,
    color: rl.Color,
    position: rl.Vector2,
    speed: rl.Vector2,
    size: rl.Vector2,
    scale: f32,

    pub fn init(path: [:0]const u8, color: rl.Color, speed: f32, scale: f32) Logo {
        const texture = rl.loadTexture(path);

        return .{
            .texture = texture,
            .color = color,
            .position = rl.Vector2.init(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2),
            .speed = rl.Vector2.init(speed, speed),
            .size = rl.Vector2.init(@as(f32, @floatFromInt(texture.width)) * scale, @as(f32, @floatFromInt(texture.height)) * scale),
            .scale = scale,
        };
    }

    /// changes speed while keeping direction
    pub fn changeSpeed(self: *Logo, change: f32) void {
        const new_x = @abs(self.speed.x) + change;
        if (self.speed.x < 0) {
            self.speed.x = new_x * -1;
        } else {
            self.speed.x = new_x;
        }

        const new_y = @abs(self.speed.y) + change;
        if (self.speed.y < 0) {
            self.speed.y = new_y * -1;
        } else {
            self.speed.y = new_y;
        }
    }

    pub fn setScale(self: *Logo, new_scale: f32) void {
        self.scale = new_scale;
        self.size = rl.Vector2.init(@as(f32, @floatFromInt(self.texture.width)) * new_scale, @as(f32, @floatFromInt(self.texture.height)) * new_scale);
    }

    fn collided(self: *Logo) void {
        const r = rand.random().int(u8);
        const g = rand.random().int(u8);
        const b = rand.random().int(u8);
        const color = rl.Color{ .r = r, .g = g, .b = b, .a = 255 };
        self.color = color;
    }

    pub fn update(self: *Logo) void {
        // delta time
        const dt = rl.getFrameTime();

        // y collision check
        if (self.position.y <= 0 or self.position.y + self.size.y >= SCREEN_HEIGHT) {
            self.speed.y *= -1;
            self.collided();
        }

        // x collision check
        if (self.position.x <= 0 or self.position.x + self.size.x >= SCREEN_WIDTH) {
            self.speed.x *= -1;
            self.collided();
        }

        self.position = rlm.vector2Add(self.position, rlm.vector2Scale(self.speed, dt));
    }

    pub fn draw(self: *Logo) void {
        rl.drawTextureEx(self.texture, self.position, 0, self.scale, self.color);
    }
};

pub fn main() anyerror!void {
    rl.initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "raylib-zig DVD logo");
    defer rl.closeWindow();

    var logo = Logo.init("dvd_logo.png", rl.Color.red, 100, 0.1);

    var hide_text = false;

    rl.setTargetFPS(60);
    while (!rl.windowShouldClose()) {
        ///////////////////////////////////////////////////////////////////////
        // UPDATE
        ///////////////////////////////////////////////////////////////////////
        // scale
        if (rl.isKeyPressed(.key_up)) logo.setScale(logo.scale + 0.05);
        if (rl.isKeyPressed(.key_down)) logo.setScale(logo.scale - 0.05);

        // speed
        if (rl.isKeyPressed(.key_left)) logo.changeSpeed(-50);
        if (rl.isKeyPressed(.key_right)) logo.changeSpeed(50);

        // hide/show text
        if (rl.isKeyPressed(.key_space)) hide_text = !hide_text;

        logo.update();

        ///////////////////////////////////////////////////////////////////////
        // DRAW
        ///////////////////////////////////////////////////////////////////////
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.black);

        logo.draw();

        if (!hide_text) {
            rl.drawText("up/down to change scale", 10, 10, 15, rl.Color.white);
            rl.drawText("left/right to change speed", 10, 30, 15, rl.Color.white);
            rl.drawText("spacebar to hide/show text", 10, 50, 15, rl.Color.white);
            rl.drawFPS(10, SCREEN_HEIGHT - 25);
        }
    }
}
