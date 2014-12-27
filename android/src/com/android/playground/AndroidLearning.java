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
import android.widget.LinearLayout;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.RadioButton;
import java.util.List;

// --- //

public class AndroidLearning extends Activity
{
    public enum Strength { WEAK, MEDIUM, STRONG };
    
    public final static String EXTRA_MSG = "com.android.playground.MESSAGE";
    private static final int NOTIFICATION_ID = 1;
    private static final int GENERIC_NOTIFICATION = 2;
    private static Strength currStrength = Strength.WEAK;
    private static boolean service_on = false;
    private static List<ScanResult> wifiFields = null;

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
                    LinearLayout ll = (LinearLayout)findViewById(R.id.masterLayout);

                    for(ScanResult sr : rs) {
                        TextView t = new TextView(c);
                        t.setText(sr.SSID + " " + sr.level);
                        ll.addView(t);
                    }

                    wifiFields = rs;

                    if(inWifi()) {
                        genericNotification("You are in a Wifi field!");
                    }
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
        if(((Switch)v).isChecked()) {
            // TODO: Make a scan here.
            service_on = true;
            refresh(v);
        } else {
            service_on = false;
        }
    }

    public void refresh(View v) {
        WifiManager wm;

        if(service_on) {
            wm = (WifiManager)getSystemService(WIFI_SERVICE);
            wm.startScan();
        }

        /* Eventually I'll need a WifiLock.
         * https://developer.android.com/reference/android/net/wifi/WifiManager.WifiLock.html
         * Use `acquire()` and `release()`.
         */
    }

    public void strengthSelected(View v) {
        if(((RadioButton)v).isChecked()) {
            switch(v.getId()) {
            case R.id.radio_strong:
                currStrength = Strength.STRONG;
                break;
            case R.id.radio_medium:
                currStrength = Strength.MEDIUM;
                break;
            default:
                currStrength = Strength.WEAK;
                break;
            }

            refresh(v);
        }
    }

    private Strength asStrength(int i) {
        if(i < -90) {
            return Strength.STRONG;
        } else if(i < -50) {
            return Strength.MEDIUM;
        } else {
            return Strength.WEAK;
        }
    }
    
    private boolean inWifi() {
        for(ScanResult sr : wifiFields) {
            if(currStrength == asStrength(sr.level)) {
                return true;
            }
        }

        return false;
    }

    /* Testing if user was in this field in the last scan */
    private boolean alreadyInField(ScanResult c) {
        for(ScanResult wf : wifiFields) {
            if(c.SSID == wf.SSID) {
                return true;
            }
        }

        return false;
    }

    /* Can trigger on two conditions:
     * 1. A new SSID is detected with a Strength passing the threshold.
     * 2. The strength of a field the user was in before passes the threshold.
     */
    private boolean enteredWifi(List<ScanResult> curr) {
        for(ScanResult c : curr) {
            // TODO: Check if `alreadyinField`.
            // If so, are their strengths different? If so, is the curr
            // one crossing the threshold? If so, notify and finish.
        }

        return false;
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
