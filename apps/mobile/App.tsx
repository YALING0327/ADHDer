import { StatusBar } from 'expo-status-bar';
import React, { useEffect, useState } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { SafeAreaView, View, StyleSheet } from 'react-native';
import { Colors } from './src/ui/colors';
import { Spacing } from './src/ui/spacing';
import { Title, Body, Caption } from './src/ui/text';
import { Screen, Card, PrimaryButton } from './src/ui/components';
import LoginScreen from './screens/LoginScreen';
import FocusScreenNew from './screens/FocusScreenNew';
import FidgetScreenNew from './screens/FidgetScreenNew';
import EducationScreenNew from './screens/EducationScreenNew';
import { getToken } from './src/auth';

const Tab = createBottomTabNavigator();

function HomeScreen() {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <View style={styles.header}>
          <Title style={styles.title}>你好，专注者</Title>
          <Caption style={styles.subtitle}>今天想做什么？先做第1小步</Caption>
        </View>

        <View style={styles.quickActions}>
          <Card style={styles.actionCard}>
            <Title style={styles.actionTitle}>开始专注</Title>
            <Caption style={styles.actionSubtitle}>25分钟番茄钟</Caption>
            <PrimaryButton 
              title="开始专注" 
              onPress={() => {
                // 导航到专注屏幕
                console.log('开始专注');
              }} 
            />
          </Card>

          <Card style={styles.actionCard}>
            <Title style={styles.actionTitle}>记录想法</Title>
            <Caption style={styles.actionSubtitle}>快速捕捉灵感</Caption>
            <PrimaryButton 
              title="记录想法" 
              onPress={() => {
                console.log('记录想法');
              }} 
            />
          </Card>

          <Card style={styles.actionCard}>
            <Title style={styles.actionTitle}>佛珠微游戏</Title>
            <Caption style={styles.actionSubtitle}>让手指忙碌起来</Caption>
            <PrimaryButton 
              title="拨珠" 
              onPress={() => {
                console.log('佛珠游戏');
              }} 
            />
          </Card>
        </View>

        <View style={styles.statsSection}>
          <Title style={styles.sectionTitle}>今日概览</Title>
          <View style={styles.statsRow}>
            <View style={styles.statItem}>
              <Body style={styles.statValue}>0</Body>
              <Caption style={styles.statLabel}>专注次数</Caption>
            </View>
            <View style={styles.statItem}>
              <Body style={styles.statValue}>0h</Body>
              <Caption style={styles.statLabel}>专注时长</Caption>
            </View>
            <View style={styles.statItem}>
              <Body style={styles.statValue}>0</Body>
              <Caption style={styles.statLabel}>完成任务</Caption>
            </View>
          </View>
        </View>
      </View>
    </SafeAreaView>
  );
}

function TasksScreen() {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Title style={styles.screenTitle}>待办任务</Title>
        <Card style={styles.emptyCard}>
          <Body style={styles.emptyText}>暂无任务</Body>
          <Caption style={styles.emptySubtext}>点击下方按钮添加第一个任务</Caption>
        </Card>
      </View>
    </SafeAreaView>
  );
}

function IdeasScreen() {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Title style={styles.screenTitle}>想法记录</Title>
        <Card style={styles.emptyCard}>
          <Body style={styles.emptyText}>暂无想法</Body>
          <Caption style={styles.emptySubtext}>随时记录你的灵感和想法</Caption>
        </Card>
      </View>
    </SafeAreaView>
  );
}

function SleepScreen() {
  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <Title style={styles.screenTitle}>助眠音景</Title>
        <Card style={styles.emptyCard}>
          <Body style={styles.emptyText}>暂无音景</Body>
          <Caption style={styles.emptySubtext}>选择适合的音景帮助入睡</Caption>
        </Card>
      </View>
    </SafeAreaView>
  );
}

export default function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    checkAuth();
  }, []);

  const checkAuth = async () => {
    try {
      const token = await getToken();
      setIsLoggedIn(!!token);
    } catch (error) {
      console.error('Auth check failed:', error);
    } finally {
      setIsLoading(false);
    }
  };

  if (isLoading) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={styles.loadingContainer}>
          <Title>ADHDer</Title>
          <Caption>加载中...</Caption>
        </View>
      </SafeAreaView>
    );
  }

  if (!isLoggedIn) {
    return <LoginScreen onLoggedIn={() => setIsLoggedIn(true)} />;
  }

  return (
    <NavigationContainer>
      <StatusBar style="auto" />
      <Tab.Navigator
        screenOptions={{
          tabBarStyle: {
            backgroundColor: Colors.backgroundElevated,
            borderTopColor: Colors.border,
            height: 60,
            paddingBottom: 8,
            paddingTop: 8,
          },
          tabBarActiveTintColor: Colors.primary,
          tabBarInactiveTintColor: Colors.textSecondary,
          tabBarLabelStyle: {
            fontSize: 12,
            fontWeight: '500',
          },
          headerStyle: {
            backgroundColor: Colors.backgroundElevated,
            borderBottomColor: Colors.border,
          },
          headerTitleStyle: {
            color: Colors.textPrimary,
            fontWeight: '600',
          },
        }}
      >
        <Tab.Screen 
          name="首页" 
          component={HomeScreen}
          options={{
            tabBarLabel: '首页',
          }}
        />
        <Tab.Screen 
          name="专注" 
          component={FocusScreenNew}
          options={{
            tabBarLabel: '专注',
          }}
        />
        <Tab.Screen 
          name="佛珠" 
          component={FidgetScreenNew}
          options={{
            tabBarLabel: '佛珠',
          }}
        />
        <Tab.Screen 
          name="知识" 
          component={EducationScreenNew}
          options={{
            tabBarLabel: '知识',
          }}
        />
        <Tab.Screen 
          name="待办" 
          component={TasksScreen}
          options={{
            tabBarLabel: '待办',
          }}
        />
      </Tab.Navigator>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  content: {
    flex: 1,
    padding: Spacing.screenPadding,
  },
  loadingContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  header: {
    alignItems: 'center',
    marginBottom: Spacing.xl,
  },
  title: {
    marginBottom: Spacing.s,
    textAlign: 'center',
  },
  subtitle: {
    textAlign: 'center',
    color: Colors.textSecondary,
  },
  quickActions: {
    marginBottom: Spacing.xl,
  },
  actionCard: {
    marginBottom: Spacing.m,
  },
  actionTitle: {
    marginBottom: Spacing.xs,
  },
  actionSubtitle: {
    marginBottom: Spacing.m,
    color: Colors.textSecondary,
  },
  statsSection: {
    marginBottom: Spacing.l,
  },
  sectionTitle: {
    marginBottom: Spacing.m,
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  statItem: {
    alignItems: 'center',
  },
  statValue: {
    fontSize: 24,
    fontWeight: '700',
    color: Colors.primary,
    marginBottom: Spacing.xs,
  },
  statLabel: {
    color: Colors.textSecondary,
  },
  screenTitle: {
    marginBottom: Spacing.l,
  },
  emptyCard: {
    alignItems: 'center',
    paddingVertical: Spacing.xxl,
  },
  emptyText: {
    marginBottom: Spacing.s,
    color: Colors.textSecondary,
  },
  emptySubtext: {
    color: Colors.textTertiary,
    textAlign: 'center',
  },
});
