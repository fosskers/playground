package com.android.playground;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.wifi.WifiManager;
import android.net.wifi.ScanResult;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.Switch;
import java.util.List;

// --- //

public class AndroidLearning extends Activity
{
    public final static String EXTRA_MSG = "com.android.playground.MESSAGE";
    public static final int NOTIFICATION_ID = 1;
    public static final int GENERIC_NOTIFICATION = 2;
    public static boolean service_on = false;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        IntentFilter i = new IntentFilter();
        i.addAction(WifiManager.SCAN_RESULTS_AVAILABLE_ACTION);
        registerReceiver(new BroadcastReceiver() {
                public void onReceive(Context c, Intent i) {
                    // Code to execute when the event occurs!
                    WifiManager wm = (WifiManager)c
                        .getSystemService(Context.WIFI_SERVICE);
                    
                    List<ScanResult> rs = wm.getScanResults();  // <List>!

                    genericNotification("Signals: " + rs.size());
                }
            }, i);
        
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

    public void refresh(View v) {
        WifiManager wm;

        if(service_on) {
            wm = (WifiManager)getSystemService(WIFI_SERVICE);
            genericNotification(
                "Wifi on? " + String.valueOf(wm.isWifiEnabled())
            );
            wm.startScan();
        }

        /* Eventually I'll need a WifiLock.
         * https://developer.android.com/reference/android/net/wifi/WifiManager.WifiLock.html
         * Use `acquire()` and `release()`.
         * TODO: Find out about permissions, because this needs one.
         */
    }

    private void genericNotification(String msg) {
        NotificationCompat.Builder b = new NotificationCompat.Builder(this);
        b.setSmallIcon(R.drawable.ic_logo);
        b.setAutoCancel(true);
        b.setContentTitle(getResources().getString(R.string.notify_title));
        b.setContentText(msg);

        NotificationManager nm =
            (NotificationManager)getSystemService(NOTIFICATION_SERVICE);
        nm.notify(GENERIC_NOTIFICATION, b.build());
    }
}
