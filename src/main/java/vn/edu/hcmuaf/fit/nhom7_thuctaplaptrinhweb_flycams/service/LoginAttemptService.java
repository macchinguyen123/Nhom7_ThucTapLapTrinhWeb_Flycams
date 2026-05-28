package vn.edu.hcmuaf.fit.nhom7_thuctaplaptrinhweb_flycams.service;

import java.util.concurrent.ConcurrentHashMap;

public class LoginAttemptService {
    private static final int MAX_ATTEMPTS = 5;
    private static final long LOCK_TIME_DURATION = 5 * 60 * 1000;
    private static final ConcurrentHashMap<String, Attempt> attemptCache = new ConcurrentHashMap<>();
    private static class Attempt {
        int count;
        long lockTime;
        Attempt() {
            this.count = 0;
            this.lockTime = 0;
        }
    }
    public static boolean isLocked(String key) {
        if (key == null) return false;
        Attempt attempt = attemptCache.get(key);
        if (attempt == null || attempt.lockTime == 0) {
            return false;
        }
        long elapsed = System.currentTimeMillis() - attempt.lockTime;
        if (elapsed > LOCK_TIME_DURATION) {
            attemptCache.remove(key);
            return false;
        }
        return true;
    }
    public static void failAttempt(String key) {
        if (key == null) return;
        Attempt attempt = attemptCache.computeIfAbsent(key, k -> new Attempt());
        if (attempt.lockTime > 0) {
            return;
        }
        attempt.count++;
        if (attempt.count >= MAX_ATTEMPTS) {
            attempt.lockTime = System.currentTimeMillis();
        }
    }
    public static void successAttempt(String key) {
        if (key == null) return;
        attemptCache.remove(key);
    }
    public static long getRemainingLockTime(String key) {
        if (key == null) return 0;
        Attempt attempt = attemptCache.get(key);
        if (attempt == null || attempt.lockTime == 0) {
            return 0;
        }
        long elapsed = System.currentTimeMillis() - attempt.lockTime;
        long remaining = LOCK_TIME_DURATION - elapsed;
        return Math.max(remaining, 0);
    }
}