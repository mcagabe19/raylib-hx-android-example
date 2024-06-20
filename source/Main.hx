package;

class Main
{
	public static function main():Void
	{
		var screenWidth = 800;
		var screenHeight = 450;

		Raylib.initWindow(screenWidth, screenHeight, "[Core] - 3D camera mode");
		Raylib.setTargetFPS(60);

		var camera = Raylib.Camera3D.create();
		camera.position = Raylib.Vector3.create(0, 10, 10);
		camera.target = Raylib.Vector3.create(0, 0, 0);
		camera.up = Raylib.Vector3.create(0, 1, 0);
		camera.fovy = 45;
		camera.projection = Raylib.CameraProjection.PERSPECTIVE;

		var cubePosition = Raylib.Vector3.create(0, 0, 0);

		while (!Raylib.windowShouldClose())
		{
			Raylib.beginDrawing();
			Raylib.clearBackground(Raylib.Colors.RAYWHITE);

			Raylib.beginMode3D(camera);
			Raylib.drawCube(cubePosition, 2, 2, 2, Raylib.Colors.RED);
			Raylib.drawCubeWires(cubePosition, 2, 2, 2, Raylib.Colors.MAROON);

			Raylib.drawGrid(10, 1);
			Raylib.endMode3D();

			Raylib.drawText("Welcome to the third dimension!", 10, 40, 20, Raylib.Colors.DARKGRAY);
			Raylib.drawFPS(10, 10);

			Raylib.endDrawing();
		}

		Raylib.closeWindow();
	}
}
