package com.android.playground;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.EditText;
import android.view.View;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;

// --- //

public class AndroidLearning extends Activity
{
    public final static String EXTRA_MSG = "com.android.playground.MESSAGE";

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
    }

    /* Named in `main.xml` */
    public void sendMessage(View v) {
        Intent i   = new Intent(this, DisplayMessageActivity.class);
        EditText e = (EditText)findViewById(R.id.edit_message);
        String m   = e.getText().toString();

        i.putExtra(EXTRA_MSG, m);
        startActivity(i);
    }

    /* Create options menu */
    @Override
    public boolean onCreateOptionsMenu(Menu m) {
        MenuInflater i = getMenuInflater();
        i.inflate(R.menu.actionbar, m);
        return super.onCreateOptionsMenu(m);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem i) {
        switch(i.getItemId()) {
        case R.id.action_search:
            //            openSearch();
            return true;
        case R.id.action_settings:
            //            openSettings();
            return true;
        default:
            return super.onOptionsItemSelected(i);
        }
    }
}
