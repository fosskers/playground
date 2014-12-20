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

// --- //

public class AndroidLearning extends Activity
{
    public final static String EXTRA_MSG = "com.android.playground.MESSAGE";
    public static final int NOTIFICATION_ID = 1;

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

    /* Notify the user */
    public void notify(View v) {
        NotificationCompat.Builder b = new NotificationCompat.Builder(this);
        b.setSmallIcon(R.drawable.icon_search);
        b.setAutoCancel(true);
        b.setContentTitle("Best Notification");
        b.setContentText("Warning: You have been notified!");
        b.setSubText("This is subtext.");

        NotificationManager nm =
            (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
        nm.notify(NOTIFICATION_ID, b.build());
    }
}
