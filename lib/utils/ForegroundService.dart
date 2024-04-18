// In your Android foreground service class
import 'dart:developer';

final public class TrackingForegroundService extends Service {

    private BroadcastReceiver shutdownReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            // Intercept the shutdown action
            // Prompt the user for authentication
            // If authentication succeeds, allow the shutdown
            // If authentication fails, cancel the shutdown
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();
        registerReceiver(shutdownReceiver, new IntentFilter(Intent.ACTION_SHUTDOWN));
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        unregisterReceiver(shutdownReceiver);
    }
}
