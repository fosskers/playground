package com.android.playground;

import android.app.Activity;
import android.os.Bundle;
import android.view.*;
import android.app.Fragment;
import android.content.Intent;
import android.widget.TextView;

// --- //

public class DisplayMessageActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent i = getIntent();
        String m = i.getStringExtra(AndroidLearning.EXTRA_MSG);
        TextView tv = new TextView(this);

        tv.setTextSize(40);
        tv.setText(m);

        setContentView(tv);
    }

    /*
    @Override
    public boolean onOptionsItemSelected(MenuItem i) {
        int id = i.getItemId();
        if(id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(i);
    }

    public static class PlaceholderFragment extends Fragment {
        public PlaceholderFragment() {}

        @Override
        public View onCreateView(LayoutInflater i, ViewGroup c, Bundle b) {
            View v = i.inflate(R.layout.fragment_display_message, c, false);

            return v;
        }
    }
    */
}
