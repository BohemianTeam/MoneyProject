package vn.lmchanh.lib.widget.fragment;

import android.content.Context;
import android.os.Bundle;
import android.view.View;

public abstract class MCFragment {
	//======================================================================================
	
	private Bundle mEmbedData;
	protected Context mContext;
	
	//======================================================================================

	protected MCFragment(Context context) {
		this.mContext = context;
		this.onCreate();
	}
	
	public void onCreate() {

	}
	
	//======================================================================================

	public abstract View getView();

	public void setEmbedData(Bundle data) {
		this.mEmbedData = data;
	}

	protected Bundle getEmbedData() {
		return this.mEmbedData;
	}
	
	//======================================================================================
}
