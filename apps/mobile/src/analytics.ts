// Simplified analytics without Firebase dependency
// Can be upgraded to Firebase later when real config is available

export const logEvent = async (eventName: string, parameters?: { [key: string]: any }) => {
  try {
    console.log(`Analytics event: ${eventName}`, parameters);
    // TODO: Add Firebase Analytics when config is ready
  } catch (error) {
    console.error('Failed to log analytics event:', error);
  }
};

export const logScreenView = async (screenName: string, screenClass?: string) => {
  try {
    console.log(`Screen view: ${screenName}`, { screen_class: screenClass });
    // TODO: Add Firebase Analytics when config is ready
  } catch (error) {
    console.error('Failed to log screen view:', error);
  }
};

export const setUserProperties = async (properties: { [key: string]: string }) => {
  try {
    console.log('User properties set:', properties);
    // TODO: Add Firebase Analytics when config is ready
  } catch (error) {
    console.error('Failed to set user properties:', error);
  }
};

export const logError = (error: Error, context?: string) => {
  try {
    console.error('Error logged:', error.message, context);
    // TODO: Add Firebase Crashlytics when config is ready
  } catch (crashlyticsError) {
    console.error('Failed to log error:', crashlyticsError);
  }
};

export const setUserId = async (userId: string) => {
  try {
    console.log('User ID set:', userId);
    // TODO: Add Firebase Analytics and Crashlytics when config is ready
  } catch (error) {
    console.error('Failed to set user ID:', error);
  }
};

// Common events for ADHDer app
export const logTaskCreated = (taskType: 'free' | 'ddl', hasDueDate: boolean) => {
  logEvent('task_created', {
    task_type: taskType,
    has_due_date: hasDueDate,
  });
};

export const logFocusSessionStarted = (duration: number) => {
  logEvent('focus_session_started', {
    duration_minutes: duration,
  });
};

export const logFocusSessionCompleted = (duration: number, interrupts: number) => {
  logEvent('focus_session_completed', {
    duration_minutes: duration,
    interrupts: interrupts,
  });
};

export const logSleepSessionStarted = (soundscape: string, duration: number) => {
  logEvent('sleep_session_started', {
    soundscape,
    duration_minutes: duration,
  });
};

export const logIdeaCreated = (hasText: boolean, hasAudio: boolean) => {
  logEvent('idea_created', {
    has_text: hasText,
    has_audio: hasAudio,
  });
};

export const logSearchPerformed = (query: string, resultsCount: number) => {
  logEvent('search_performed', {
    query_length: query.length,
    results_count: resultsCount,
  });
};
