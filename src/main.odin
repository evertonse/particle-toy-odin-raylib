package main
import fmt "core:fmt"
import rl "vendor:raylib"

screen_width  :: 800;
screen_height :: 800;
particles: [100000]Particle;
main :: proc() {
    // Initialization
    //--------------------------------------------------------------------------------------

    rl.SetRandomSeed(1);


    fmt.printf("len of Particles is %v\n", len(particles))
    for i in 0..<len(particles) {
        particles[i] = particle_make_from_screen(screen_width, screen_height);
    }
    

    rl.InitWindow(screen_width, screen_height, "raylib test");

    rl.SetTargetFPS(60);               // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    // Detect window close button or ESC key
    for !rl.WindowShouldClose() {
        // Update
        //----------------------------------------------------------------------------------
        mousePos := rl.Vector2{ cast(f32)rl.GetMouseX(), cast(f32)rl.GetMouseY()};

        for i in 0..<len(particles) {
            particle_attract(&particles[i],mousePos, 1)
            particle_do_friction(&particles[i], 0.99)
            particle_move(&particles[i], screen_width, screen_height)
            
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        rl.BeginDrawing();

            rl.ClearBackground(rl.RAYWHITE);

            for i in 0..<len(particles) {
                particle_draw_pixel(&particles[i]);
            }

            rl.DrawFPS(10, 10);

        rl.EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    rl.CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------
}

