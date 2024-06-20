package org.haxe.raylib;

import android.app.AlertDialog;
import android.app.NativeActivity;
import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;

public class NativeLoader extends NativeActivity
{
	private boolean brokenLibraries = false;
	private String errorMsgBrokenLib = "";

	// Loading method of your native application
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN |
			View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
			View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY |
			View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
			View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION |
			View.SYSTEM_UI_FLAG_LAYOUT_STABLE);

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
		{
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().getAttributes().layoutInDisplayCutoutMode =
				WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_ALWAYS;
		}
		else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)
		{
			getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
			getWindow().getAttributes().layoutInDisplayCutoutMode =
				WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
		}

		try
		{
			super.onCreate(savedInstanceState);
		}
		catch (UnsatisfiedLinkError e)
		{
			System.err.println(e.getMessage());

			brokenLibraries = true;

			errorMsgBrokenLib = e.getMessage();
		}
		catch (Exception e)
		{
			System.err.println(e.getMessage());

			brokenLibraries = true;

			errorMsgBrokenLib = e.getMessage();
		}

		if (brokenLibraries)
		{
			AlertDialog.Builder dlgAlert  = new AlertDialog.Builder(this);
			dlgAlert.setMessage("An error occurred while trying to start the application. Please try again and/or reinstall."
					    + System.getProperty("line.separator")
					    + System.getProperty("line.separator")
					    + "Error: " + errorMsgBrokenLib);
			dlgAlert.setTitle("Loading Error");
			dlgAlert.setPositiveButton("Exit", new DialogInterface.OnClickListener()
			{
				@Override
				public void onClick(DialogInterface dialog, int id)
				{
					finish();
				}
			});
			dlgAlert.setCancelable(false);
			dlgAlert.create().show();
		}
	}

	// Handling loss and regain of application focus
	@Override
	public void onWindowFocusChanged(boolean hasFocus)
	{
		super.onWindowFocusChanged(hasFocus);

		if (hasFocus)
		{
			// If the app has focus, re-enable immersive mode
			getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN |
				View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
				View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY |
				View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
				View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION |
				View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
		}
	}
}
