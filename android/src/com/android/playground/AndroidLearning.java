package com.android.playground;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.Switch;

// --- //

public class AndroidLearning extends Activity
{
    public final static String EXTRA_MSG = "com.android.playground.MESSAGE";
    public static final int NOTIFICATION_ID = 1;
    public static boolean service_on = false;

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

    /* Turn functionality on/off and notify user */
    public void switchPress(View v) {
        NotificationCompat.Builder b = new NotificationCompat.Builder(this);
        b.setSmallIcon(R.drawable.ic_logo);
        b.setAutoCancel(true);
        b.setContentTitle(getResources().getString(R.string.notify_title));

        if(((Switch)v).isChecked()) {
            b.setContentText(getResources().getString(R.string.notify_on));
            service_on = true;
        } else {
            b.setContentText(getResources().getString(R.string.notify_off));
            service_on = false;
        }

        NotificationManager nm =
            (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
        nm.notify(NOTIFICATION_ID, b.build());
    }
}
