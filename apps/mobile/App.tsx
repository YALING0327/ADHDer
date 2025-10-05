import { StatusBar } from 'expo-status-bar';
import React, { useMemo, useRef } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { SafeAreaView, Text, View, PanResponder, GestureResponderEvent, PanResponderGestureState } from 'react-native';
import * as Haptics from 'expo-haptics';

function HomeScreen() {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24 }}>
        <Text style={{ fontSize: 28, fontWeight: '600', marginBottom: 8 }}>首页</Text>
        <Text style={{ fontSize: 18, lineHeight: 24 }}>今天第一口 · 最近DDL · 指尖佛珠</Text>
      </View>
    </SafeAreaView>
  );
}

function TasksScreen() {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24 }}>
        <Text style={{ fontSize: 28, fontWeight: '600', marginBottom: 8 }}>待办</Text>
        <Text style={{ fontSize: 18, lineHeight: 24 }}>自由/DDL · 三步拆解</Text>
      </View>
    </SafeAreaView>
  );
}

function FocusScreen() {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24 }}>
        <Text style={{ fontSize: 28, fontWeight: '600', marginBottom: 8 }}>专注</Text>
        <Text style={{ fontSize: 18, lineHeight: 24 }}>25/45/60 倒计时 + 中断回归</Text>
      </View>
    </SafeAreaView>
  );
}

function FidgetScreen() {
  const lastTickRef = useRef(0);
  const panResponder = useMemo(
    () =>
      PanResponder.create({
        onStartShouldSetPanResponder: () => true,
        onMoveShouldSetPanResponder: () => true,
        onPanResponderGrant: async () => {
          await Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
          lastTickRef.current = 0;
        },
        onPanResponderMove: async (_evt: GestureResponderEvent, gestureState: PanResponderGestureState) => {
          const distance = Math.sqrt(gestureState.dx * gestureState.dx + gestureState.dy * gestureState.dy);
          if (distance - lastTickRef.current > 24) {
            lastTickRef.current = distance;
            await Haptics.selectionAsync();
          }
        },
        onPanResponderRelease: async () => {
          await Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
        },
        onPanResponderTerminationRequest: () => true,
      }),
    []
  );

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#000' }}>
      <View style={{ padding: 24 }}>
        <Text style={{ fontSize: 28, fontWeight: '600', marginBottom: 8, color: '#fff' }}>指尖佛珠</Text>
        <Text style={{ fontSize: 18, lineHeight: 24, color: '#ddd' }}>滑动/捻动/长按 · 细微触觉</Text>
      </View>
      <View
        style={{ flex: 1, alignItems: 'center', justifyContent: 'center' }}
        {...panResponder.panHandlers}
      >
        <View style={{ width: 220, height: 220, borderRadius: 110, borderColor: '#333', borderWidth: 2, alignItems: 'center', justifyContent: 'center' }}>
          <View style={{ width: 32, height: 32, borderRadius: 16, backgroundColor: '#888' }} />
        </View>
      </View>
    </SafeAreaView>
  );
}

function IdeasScreen() {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24 }}>
        <Text style={{ fontSize: 28, fontWeight: '600', marginBottom: 8 }}>想法</Text>
        <Text style={{ fontSize: 18, lineHeight: 24 }}>全屏输入/语音（后续） · Inbox</Text>
      </View>
    </SafeAreaView>
  );
}

function SleepScreen() {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24 }}>
        <Text style={{ fontSize: 28, fontWeight: '600', marginBottom: 8 }}>助眠</Text>
        <Text style={{ fontSize: 18, lineHeight: 24 }}>白噪/自然/Lo‑fi/呼吸节拍 · 定时</Text>
      </View>
    </SafeAreaView>
  );
}

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator screenOptions={{ headerShown: false }}>
        <Tab.Screen name="首页" component={HomeScreen} />
        <Tab.Screen name="待办" component={TasksScreen} />
        <Tab.Screen name="专注" component={FocusScreen} />
        <Tab.Screen name="佛珠" component={FidgetScreen} />
        <Tab.Screen name="想法" component={IdeasScreen} />
        <Tab.Screen name="助眠" component={SleepScreen} />
      </Tab.Navigator>
      <StatusBar style="auto" />
    </NavigationContainer>
  );
}


