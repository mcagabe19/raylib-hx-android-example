package org.haxe.raylib;

import android.app.NativeActivity;
import android.os.Build;
import android.os.Bundle;
import android.view.WindowManager;

public class NativeLoader extends NativeActivity
{
	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R)
		{
			getWindow().getAttributes().layoutInDisplayCutoutMode =
				WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_ALWAYS;
		}
		else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)
		{
			getWindow().getAttributes().layoutInDisplayCutoutMode =
				WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
		}

		super.onCreate(savedInstanceState);
	}
}
