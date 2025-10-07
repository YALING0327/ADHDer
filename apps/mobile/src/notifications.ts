import * as Notifications from 'expo-notifications';
import { Platform } from 'react-native';

// Configure notification behavior
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: false,
  }),
});

export async function requestPermissions(): Promise<boolean> {
  const { status: existingStatus } = await Notifications.getPermissionsAsync();
  let finalStatus = existingStatus;
  
  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }
  
  if (finalStatus !== 'granted') {
    console.log('Failed to get push token for push notification!');
    return false;
  }
  
  return true;
}

export async function scheduleTaskNotification(
  taskId: string,
  title: string,
  dueDate: Date,
  reminderMinutes: number = 30
): Promise<string | null> {
  const hasPermission = await requestPermissions();
  if (!hasPermission) return null;

  const triggerDate = new Date(dueDate.getTime() - reminderMinutes * 60 * 1000);
  
  // Don't schedule if the reminder time has already passed
  if (triggerDate <= new Date()) {
    console.log('Reminder time has already passed');
    return null;
  }

  const notificationId = await Notifications.scheduleNotificationAsync({
    content: {
      title: '📅 任务提醒',
      body: `${title} 将在 ${reminderMinutes} 分钟后到期`,
      data: { taskId, type: 'task_reminder' },
    },
    trigger: triggerDate,
  });

  console.log(`Scheduled notification ${notificationId} for task ${taskId}`);
  return notificationId;
}

export async function cancelNotification(notificationId: string): Promise<void> {
  await Notifications.cancelScheduledNotificationAsync(notificationId);
}

export async function cancelAllNotifications(): Promise<void> {
  await Notifications.cancelAllScheduledNotificationsAsync();
}

export async function getScheduledNotifications() {
  return await Notifications.getAllScheduledNotificationsAsync();
}
