package;

class Main
{
	public static function main():Void
	{
		var screenWidth = 800;
		var screenHeight = 450;

		Raylib.initWindow(screenWidth, screenHeight, "raylib [textures] example - background scrolling");

		// NOTE: Be careful, background width must be equal or bigger than screen width
		// if not, texture should be drawn more than two times for scrolling effect
		var background = Raylib.loadTexture("resources/cyberpunk_street_background.png");
		var midground = Raylib.loadTexture("resources/cyberpunk_street_midground.png");
		var foreground = Raylib.loadTexture("resources/cyberpunk_street_foreground.png");

		var scrollingBack = 0.0;
		var scrollingMid = 0.0;
		var scrollingFore = 0.0;

		Raylib.setTargetFPS(60); // Set our game to run at 60 frames-per-second

		// Main game loop
		while (!Raylib.windowShouldClose()) // Detect window close button or ESC key
		{
			// Update
			scrollingBack -= 0.1;
			scrollingMid -= 0.5;
			scrollingFore -= 1.0;

			// NOTE: Texture is scaled twice its size, so it should be considered on scrolling
			if (scrollingBack <= -background.width * 2)
				scrollingBack = 0;

			if (scrollingMid <= -midground.width * 2)
				scrollingMid = 0;

			if (scrollingFore <= -foreground.width * 2)
				scrollingFore = 0;

			// Draw
			Raylib.beginDrawing();

			Raylib.clearBackground(Raylib.getColor(0x052c46ff));

			// Draw background image twice
			// NOTE: Texture is scaled twice its size
			Raylib.drawTextureEx(background, {x: scrollingBack, y: 20}, 0.0, 2.0, Raylib.WHITE);
			Raylib.drawTextureEx(background, {x: background.width * 2 + scrollingBack, y: 20}, 0.0, 2.0, Raylib.WHITE);

			// Draw midground image twice
			Raylib.drawTextureEx(midground, {x: scrollingMid, y: 20}, 0.0, 2.0, Raylib.WHITE);
			Raylib.drawTextureEx(midground, {x: midground.width * 2 + scrollingMid, y: 20}, 0.0, 2.0, Raylib.WHITE);

			// Draw foreground image twice
			Raylib.drawTextureEx(foreground, {x: scrollingFore, y: 70}, 0.0, 2.0, Raylib.WHITE);
			Raylib.drawTextureEx(foreground, {x: foreground.width * 2 + scrollingFore, y: 70}, 0.0, 2.0, Raylib.WHITE);

			Raylib.drawText("BACKGROUND SCROLLING & PARALLAX", 10, 10, 20, Raylib.RED);
			Raylib.drawText("(c) Cyberpunk Street Environment by Luis Zuno (@ansimuz)", screenWidth - 330, screenHeight - 20, 10, Raylib.RAYWHITE);

			Raylib.endDrawing();
		}

		// De-Initialization
		Raylib.unloadTexture(background); // Unload background texture
		Raylib.unloadTexture(midground); // Unload midground texture
		Raylib.unloadTexture(foreground); // Unload foreground texture

		Raylib.closeWindow(); // Close window and OpenGL context
	}
}
