import React, { useState, useEffect } from 'react';
import { SafeAreaView, View, StyleSheet, Alert } from 'react-native';
import { FidgetBeads } from '../src/ui/FidgetBeads';
import { Card } from '../src/ui/components';
import { Title, Body, Caption } from '../src/ui/text';
import { Colors } from '../src/ui/colors';
import { Spacing } from '../src/ui/spacing';

export default function FidgetScreenNew() {
  const [interactionCount, setInteractionCount] = useState(0);
  const [sessionStartTime] = useState(new Date());

  const handleInteraction = () => {
    setInteractionCount(prev => prev + 1);
  };

  const handleAutoPrompt = () => {
    Alert.alert(
      '回到专注',
      '你已经在这里待了一会儿，要不要回到正在听的内容？',
      [
        { text: '继续拨珠', style: 'cancel' },
        { text: '回到学习', onPress: () => {
          // 这里可以导航回之前的屏幕
          console.log('回到学习');
        }}
      ]
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <View style={styles.header}>
          <Title style={styles.title}>佛珠微游戏</Title>
          <Caption style={styles.subtitle}>
            轻轻拨动珠子，让手指忙碌起来
          </Caption>
        </View>

        <View style={styles.beadsContainer}>
          <FidgetBeads
            count={12}
            onInteraction={handleInteraction}
            autoPromptDelay={60000} // 60秒后提示
            onAutoPrompt={handleAutoPrompt}
          />
        </View>

        <Card style={styles.infoCard}>
          <Body style={styles.infoText}>
            这是一个简单的微游戏，没有得分，没有排行榜。
            只是让你的手指有个地方忙碌，帮助保持专注。
          </Body>
        </Card>

        <Card style={styles.tipsCard}>
          <Title style={styles.tipsTitle}>小贴士</Title>
          <View style={styles.tipsList}>
            <Caption style={styles.tipItem}>• 拨珠时保持呼吸平稳</Caption>
            <Caption style={styles.tipItem}>• 感受手指的触感</Caption>
            <Caption style={styles.tipItem}>• 60秒后会有温柔提醒</Caption>
            <Caption style={styles.tipItem}>• 这只是辅助，不是主要任务</Caption>
          </View>
        </Card>
      </View>
    </SafeAreaView>
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
  beadsContainer: {
    alignItems: 'center',
    marginBottom: Spacing.xl,
  },
  infoCard: {
    marginBottom: Spacing.l,
    backgroundColor: Colors.surface,
  },
  infoText: {
    color: Colors.textPrimary,
    lineHeight: 22,
  },
  tipsCard: {
    backgroundColor: Colors.backgroundElevated,
  },
  tipsTitle: {
    marginBottom: Spacing.m,
    color: Colors.textPrimary,
  },
  tipsList: {
    gap: Spacing.s,
  },
  tipItem: {
    color: Colors.textSecondary,
    lineHeight: 20,
  },
});
