package org.haxe.raylib;

import android.app.AlertDialog;
import android.app.NativeActivity;
import android.content.DialogInterface;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.view.WindowManager;

public class NativeLoader extends NativeActivity
{
	private boolean brokenLibraries = false;
	private String errorMsgBrokenLib = "";

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		setImmersiveMode();

		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
		{
			WindowManager.LayoutParams params = getWindow().getAttributes();
			params.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_ALWAYS;
			getWindow().setAttributes(params);
		}
		else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)
		{
			WindowManager.LayoutParams params = getWindow().getAttributes();
			params.layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
			getWindow().setAttributes(params);
		}

		try
		{
			super.onCreate(savedInstanceState);
		}
		catch (UnsatisfiedLinkError e)
		{
			handleLoadingError(e.getMessage());
		}
		catch (Exception e)
		{
			handleLoadingError(e.getMessage());
		}
	}

	private void setImmersiveMode()
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
		{
			final WindowInsetsController controller = getWindow().getInsetsController();

			if (controller != null)
			{
				controller.hide(WindowInsets.Type.statusBars() | WindowInsets.Type.navigationBars());
				controller.setSystemBarsBehavior(WindowInsetsController.BEHAVIOR_SHOW_TRANSIENT_BARS_BY_SWIPE);
			}
		}
		else
		{
			getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_FULLSCREEN |
				View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
				View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY |
				View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
				View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION |
				View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
		}
	}

	private void handleLoadingError(String errorMessage)
	{
		brokenLibraries = true;

		errorMsgBrokenLib = errorMessage;

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

	@Override
	public void onWindowFocusChanged(boolean hasFocus)
	{
		super.onWindowFocusChanged(hasFocus);

		if (hasFocus)
			setImmersiveMode();
	}
}
