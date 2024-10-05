package;

import Raylib;

class CircleWave
{
	public var position:Vector2;
	public var radius:Float;
	public var alpha:Float;
	public var speed:Float;
	public var color:Color;
}

class Main
{
	private static final MAX_CIRCLES:Int = 64;

	public static function main():Void
	{
		final screenWidth:Int = 800;
		final screenHeight:Int = 450;

		Raylib.setConfigFlags(FLAG_MSAA_4X_HINT);

		Raylib.initWindow(screenWidth, screenHeight, "raylib [audio] example - module playing (streaming)");

		Raylib.initAudioDevice();

		final colors:Array<Color> = [
			Raylib.ORANGE, Raylib.RED, Raylib.GOLD, Raylib.LIME, Raylib.BLUE, Raylib.VIOLET, Raylib.BROWN, Raylib.LIGHTGRAY, Raylib.PINK, Raylib.YELLOW,
			Raylib.GREEN, Raylib.SKYBLUE, Raylib.PURPLE, Raylib.BEIGE
		];

		final circles:Array<CircleWave> = [];

		for (i in 0...MAX_CIRCLES)
		{
			circles[i] = new CircleWave();
			circles[i].alpha = 0.0;
			circles[i].radius = Raylib.getRandomValue(10, 40);
			circles[i].position = Vector2.create(Raylib.getRandomValue(Math.floor(circles[i].radius), Math.floor(screenWidth - circles[i].radius)),
				Raylib.getRandomValue(Math.floor(circles[i].radius), Math.floor(screenHeight - circles[i].radius)));
			circles[i].speed = Raylib.getRandomValue(1, 100) / 2000.0;
			circles[i].color = colors[Raylib.getRandomValue(0, 13)];
		}

		final music:Music = Raylib.loadMusicStream("resources/mini1111.xm");
		music.looping = false;
		Raylib.playMusicStream(music);

		var pitch:Float = 1.0;
		var timePlayed:Float = 0.0;
		var pause:Bool = false;

		Raylib.setTargetFPS(60);

		while (!Raylib.windowShouldClose())
		{
			Raylib.updateMusicStream(music);

			if (Raylib.isKeyPressed(KEY_SPACE))
			{
				Raylib.stopMusicStream(music);
				Raylib.playMusicStream(music);
				pause = false;
			}

			if (Raylib.isKeyPressed(KEY_P))
			{
				pause = !pause;

				if (pause)
					Raylib.pauseMusicStream(music);
				else
					Raylib.resumeMusicStream(music);
			}

			if (Raylib.isKeyPressed(KEY_DOWN))
				pitch -= 0.01;
			else if (Raylib.isKeyPressed(KEY_UP))
				pitch += 0.01;

			Raylib.setMusicPitch(music, pitch);

			timePlayed = Raylib.getMusicTimePlayed(music) / Raylib.getMusicTimeLength(music) * (screenWidth - 40);

			if (!pause)
			{
				for (i in 0...MAX_CIRCLES)
				{
					circles[i].alpha += circles[i].speed;
					circles[i].radius += circles[i].speed * 10.0;

					if (circles[i].alpha > 1.0)
						circles[i].speed *= -1;

					if (circles[i].alpha <= 0.0)
					{
						circles[i].alpha = 0.0;
						circles[i].radius = Raylib.getRandomValue(10, 40);
						circles[i].position = Vector2.create(Raylib.getRandomValue(Math.floor(circles[i].radius), Math.floor(screenWidth - circles[i].radius)),
							Raylib.getRandomValue(Math.floor(circles[i].radius), Math.floor(screenHeight - circles[i].radius)));
						circles[i].speed = Raylib.getRandomValue(1, 100) / 2000.0;
						circles[i].color = colors[Raylib.getRandomValue(0, 13)];
					}
				}
			}

			Raylib.beginDrawing();

			Raylib.clearBackground(Raylib.RAYWHITE);

			for (i in 0...MAX_CIRCLES)
				Raylib.drawCircleV(circles[i].position, circles[i].radius, Raylib.fade(circles[i].color, circles[i].alpha));

			Raylib.drawRectangle(20, screenHeight - 32, screenWidth - 40, 12, Raylib.LIGHTGRAY);
			Raylib.drawRectangle(20, screenHeight - 32, Math.floor(timePlayed), 12, Raylib.MAROON);
			Raylib.drawRectangleLines(20, screenHeight - 32, screenWidth - 40, 12, Raylib.GRAY);

			Raylib.drawRectangle(20, 20, 425, 145, Raylib.WHITE);
			Raylib.drawRectangleLines(20, 20, 425, 145, Raylib.GRAY);
			Raylib.drawText("PRESS SPACE TO RESTART MUSIC", 40, 40, 20, Raylib.BLACK);
			Raylib.drawText("PRESS P TO PAUSE/RESUME", 40, 70, 20, Raylib.BLACK);
			Raylib.drawText("PRESS UP/DOWN TO CHANGE SPEED", 40, 100, 20, Raylib.BLACK);
			Raylib.drawText("SPEED: " + pitch, 40, 130, 20, Raylib.MAROON);

			Raylib.endDrawing();
		}

		Raylib.unloadMusicStream(music);
		Raylib.closeAudioDevice();
		Raylib.closeWindow();
	}
}
