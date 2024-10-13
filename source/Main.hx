package;

import Raylib;
import Raygui;

class Main
{
	public static function main():Void
	{
		final screenWidth:Int = 800;
		final screenHeight:Int = 450;

		Raylib.initWindow(screenWidth, screenHeight, "raylib [shapes] example - draw circle sector");

		final center:Vector2 = new Vector2((Raylib.getScreenWidth() - 300) / 2.0, Raylib.getScreenHeight() / 2.0);

		var outerRadius:Single = 180.0;
		var startAngle:Single = 0.0;
		var endAngle:Single = 180.0;
		var segments:Single = 10.0;
		var minSegments:Single = 4;

		Raylib.setTargetFPS(60);

		while (!Raylib.windowShouldClose())
		{
			Raylib.beginDrawing();

			Raylib.clearBackground(Raylib.RAYWHITE);

			Raylib.drawLine(500, 0, 500, Raylib.getScreenHeight(), Raylib.fade(Raylib.LIGHTGRAY, 0.6));
			Raylib.drawRectangle(500, 0, Raylib.getScreenWidth() - 500, Raylib.getScreenHeight(), Raylib.fade(Raylib.LIGHTGRAY, 0.3));

			Raylib.drawCircleSector(center, outerRadius, startAngle, endAngle, Math.floor(segments), Raylib.fade(Raylib.MAROON, 0.3));
			Raylib.drawCircleSectorLines(center, outerRadius, startAngle, endAngle, Math.floor(segments), Raylib.fade(Raylib.MAROON, 0.6));

			Raygui.guiSliderBar(new Rectangle(600, 40, 120, 20), "StartAngle", Std.string(startAngle), startAngle), 0, 720);
			Raygui.guiSliderBar(new Rectangle(600, 70, 120, 20), "EndAngle", Std.string(endAngle), endAngle), 0, 720);
			Raygui.guiSliderBar(new Rectangle(600, 140, 120, 20), "Radius", Std.string(outerRadius), outerRadius, 0, 200);
			Raygui.guiSliderBar(new Rectangle(600, 170, 120, 20), "Segments", Std.string(segments), segments, 0, 100);

			minSegments = Math.floor(Math.ceil((endAngle - startAngle) / 90));

			Raylib.drawText("MODE: " + ((segments >= minSegments) ? "MANUAL" : "AUTO"), 600, 200, 10, (segments >= minSegments) ? Raylib.MAROON : Raylib.DARKGRAY);

			Raylib.drawFPS(10, 10);

			Raylib.endDrawing();
		}

		Raylib.closeWindow();
	}
}
