/**
 * Firebase Admin SDK 初始化和推送通知服务
 * 使用服务账号密钥进行认证，比 Legacy Server Key 更安全
 */

import admin from 'firebase-admin';
import nconf from 'nconf';
import fs from 'fs';
import path from 'path';

let firebaseApp = null;

/**
 * 初始化 Firebase Admin SDK
 */
export function initializeFirebaseAdmin() {
  if (firebaseApp) {
    return firebaseApp;
  }

  try {
    const serviceAccountPath = nconf.get('FIREBASE_SERVICE_ACCOUNT_PATH');
    
    if (!serviceAccountPath) {
      console.error('❌ FIREBASE_SERVICE_ACCOUNT_PATH 未配置');
      return null;
    }

    // 读取服务账号密钥
    const serviceAccountFullPath = path.resolve(process.cwd(), serviceAccountPath);
    
    if (!fs.existsSync(serviceAccountFullPath)) {
      console.error(`❌ 服务账号密钥文件不存在: ${serviceAccountFullPath}`);
      return null;
    }

    const serviceAccount = JSON.parse(fs.readFileSync(serviceAccountFullPath, 'utf8'));

    // 初始化 Firebase Admin
    firebaseApp = admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      projectId: serviceAccount.project_id,
    });

    console.log('✅ Firebase Admin SDK 初始化成功');
    return firebaseApp;
  } catch (error) {
    console.error('❌ Firebase Admin SDK 初始化失败:', error);
    return null;
  }
}

/**
 * 发送推送通知到单个设备
 * @param {string} fcmToken - 设备的 FCM Token
 * @param {Object} notification - 通知内容
 * @param {string} notification.title - 通知标题
 * @param {string} notification.body - 通知内容
 * @param {Object} data - 自定义数据（可选）
 * @returns {Promise<Object>} 发送结果
 */
export async function sendPushNotification(fcmToken, notification, data = {}) {
  if (!firebaseApp) {
    initializeFirebaseAdmin();
  }

  if (!firebaseApp) {
    throw new Error('Firebase Admin SDK 未初始化');
  }

  const message = {
    token: fcmToken,
    notification: {
      title: notification.title,
      body: notification.body,
    },
    data: data,
    // Android 特定配置
    android: {
      priority: 'high',
      notification: {
        sound: 'default',
        clickAction: 'FLUTTER_NOTIFICATION_CLICK',
      },
    },
    // iOS 特定配置
    apns: {
      payload: {
        aps: {
          sound: 'default',
          badge: 1,
        },
      },
    },
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('✅ 推送通知发送成功:', response);
    return { success: true, messageId: response };
  } catch (error) {
    console.error('❌ 推送通知发送失败:', error);
    return { success: false, error: error.message };
  }
}

/**
 * 发送推送通知到多个设备
 * @param {string[]} fcmTokens - 设备的 FCM Token 数组
 * @param {Object} notification - 通知内容
 * @param {Object} data - 自定义数据（可选）
 * @returns {Promise<Object>} 发送结果
 */
export async function sendMulticastNotification(fcmTokens, notification, data = {}) {
  if (!firebaseApp) {
    initializeFirebaseAdmin();
  }

  if (!firebaseApp) {
    throw new Error('Firebase Admin SDK 未初始化');
  }

  const message = {
    tokens: fcmTokens,
    notification: {
      title: notification.title,
      body: notification.body,
    },
    data: data,
    android: {
      priority: 'high',
      notification: {
        sound: 'default',
      },
    },
    apns: {
      payload: {
        aps: {
          sound: 'default',
        },
      },
    },
  };

  try {
    const response = await admin.messaging().sendEachForMulticast(message);
    console.log(`✅ 群发通知成功: ${response.successCount}/${fcmTokens.length}`);
    
    if (response.failureCount > 0) {
      response.responses.forEach((resp, idx) => {
        if (!resp.success) {
          console.error(`Token ${fcmTokens[idx]} 发送失败:`, resp.error);
        }
      });
    }
    
    return {
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
    };
  } catch (error) {
    console.error('❌ 群发通知失败:', error);
    return { success: false, error: error.message };
  }
}

/**
 * 发送通知到主题（Topic）
 * @param {string} topic - 主题名称
 * @param {Object} notification - 通知内容
 * @param {Object} data - 自定义数据（可选）
 * @returns {Promise<Object>} 发送结果
 */
export async function sendTopicNotification(topic, notification, data = {}) {
  if (!firebaseApp) {
    initializeFirebaseAdmin();
  }

  if (!firebaseApp) {
    throw new Error('Firebase Admin SDK 未初始化');
  }

  const message = {
    topic: topic,
    notification: {
      title: notification.title,
      body: notification.body,
    },
    data: data,
  };

  try {
    const response = await admin.messaging().send(message);
    console.log('✅ 主题通知发送成功:', response);
    return { success: true, messageId: response };
  } catch (error) {
    console.error('❌ 主题通知发送失败:', error);
    return { success: false, error: error.message };
  }
}

/**
 * 订阅设备到主题
 * @param {string|string[]} fcmTokens - FCM Token 或 Token 数组
 * @param {string} topic - 主题名称
 * @returns {Promise<Object>} 订阅结果
 */
export async function subscribeToTopic(fcmTokens, topic) {
  if (!firebaseApp) {
    initializeFirebaseAdmin();
  }

  if (!firebaseApp) {
    throw new Error('Firebase Admin SDK 未初始化');
  }

  const tokens = Array.isArray(fcmTokens) ? fcmTokens : [fcmTokens];

  try {
    const response = await admin.messaging().subscribeToTopic(tokens, topic);
    console.log(`✅ 订阅主题成功: ${response.successCount}/${tokens.length}`);
    return {
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
    };
  } catch (error) {
    console.error('❌ 订阅主题失败:', error);
    return { success: false, error: error.message };
  }
}

/**
 * 取消订阅主题
 * @param {string|string[]} fcmTokens - FCM Token 或 Token 数组
 * @param {string} topic - 主题名称
 * @returns {Promise<Object>} 取消订阅结果
 */
export async function unsubscribeFromTopic(fcmTokens, topic) {
  if (!firebaseApp) {
    initializeFirebaseAdmin();
  }

  if (!firebaseApp) {
    throw new Error('Firebase Admin SDK 未初始化');
  }

  const tokens = Array.isArray(fcmTokens) ? fcmTokens : [fcmTokens];

  try {
    const response = await admin.messaging().unsubscribeFromTopic(tokens, topic);
    console.log(`✅ 取消订阅成功: ${response.successCount}/${tokens.length}`);
    return {
      success: true,
      successCount: response.successCount,
      failureCount: response.failureCount,
    };
  } catch (error) {
    console.error('❌ 取消订阅失败:', error);
    return { success: false, error: error.message };
  }
}

export default {
  initializeFirebaseAdmin,
  sendPushNotification,
  sendMulticastNotification,
  sendTopicNotification,
  subscribeToTopic,
  unsubscribeFromTopic,
};

