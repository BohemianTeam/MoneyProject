package vn.lmchanh.lib.widget.fragment;

import java.util.Hashtable;

import android.app.Activity;
import android.os.Bundle;
import android.view.ViewGroup;

public abstract class MCFragmentActivity extends Activity {
	// ======================================================================================

	private Hashtable<Integer, MCFragment> mFragmentMap;

	// ======================================================================================

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.mFragmentMap = new Hashtable<Integer, MCFragment>();
	}

	// ======================================================================================

	public void replaceFragment(int id, MCFragment fragment) {
		Integer key = new Integer(id);
		this.mFragmentMap.remove(key);
		this.mFragmentMap.put(key, fragment);

		ViewGroup fragmentHost = (ViewGroup) this.findViewById(id);
		fragmentHost.removeAllViews();
		fragmentHost.addView(fragment.getView());
	}

	public MCFragment findFragmentById(int id) {
		return this.mFragmentMap.get(new Integer(id));
	}

	// ======================================================================================
}
