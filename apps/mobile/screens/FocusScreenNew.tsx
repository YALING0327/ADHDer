import React, { useState, useRef } from 'react';
import { SafeAreaView, View, StyleSheet, Alert } from 'react-native';
import { FocusTimerRing } from '../src/ui/FocusTimerRing';
import { ParticleBurst } from '../src/ui/ParticleBurst';
import { Card } from '../src/ui/components';
import { Title, Body, Caption } from '../src/ui/text';
import { Colors } from '../src/ui/colors';
import { Spacing } from '../src/ui/spacing';
import { api } from '../src/api';
import { logFocusSessionStarted, logFocusSessionCompleted } from '../src/analytics';

export default function FocusScreenNew() {
  const [isFocusing, setIsFocusing] = useState(false);
  const [sessionStartTime, setSessionStartTime] = useState<Date | null>(null);
  const [showParticles, setShowParticles] = useState(false);
  const [interrupts, setInterrupts] = useState(0);
  const [sessionNote, setSessionNote] = useState('');

  const handleStart = () => {
    setIsFocusing(true);
    setSessionStartTime(new Date());
    setInterrupts(0);
    logFocusSessionStarted(25); // 25分钟番茄钟
  };

  const handleComplete = async () => {
    setIsFocusing(false);
    setShowParticles(true);
    
    // 记录专注会话
    if (sessionStartTime) {
      try {
        await api.createFocusSession(25, sessionStartTime.toISOString());
        logFocusSessionCompleted(25, interrupts);
      } catch (error) {
        console.error('Failed to log focus session:', error);
      }
    }

    // 3秒后隐藏粒子效果
    setTimeout(() => {
      setShowParticles(false);
    }, 3000);

    // 显示完成提示
    Alert.alert(
      '专注完成！',
      '恭喜你完成了一次专注时间。要记录一下刚才的感受吗？',
      [
        { text: '稍后再说', style: 'cancel' },
        { text: '记录感受', onPress: () => {
          // 这里可以打开一个简单的输入框
          Alert.prompt(
            '记录感受',
            '简单记录一下刚才专注的感受：',
            (text) => {
              if (text) {
                setSessionNote(text);
                // 这里可以保存到后端
              }
            }
          );
        }}
      ]
    );
  };

  const handleTick = (remaining: number) => {
    // 每分钟记录一次进度
    if (remaining % 60 === 0 && remaining !== 0) {
      console.log(`专注进行中，剩余 ${Math.floor(remaining / 60)} 分钟`);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        <View style={styles.header}>
          <Title style={styles.title}>专注时间</Title>
          <Caption style={styles.subtitle}>
            {isFocusing ? '保持专注，你做得很好！' : '选择一个时间段，开始专注'}
          </Caption>
        </View>

        <View style={styles.timerContainer}>
          <FocusTimerRing
            durationSeconds={1500} // 25分钟
            autostart={false}
            onComplete={handleComplete}
            onTick={handleTick}
            vibrateOnTick={true}
            vibrateOnComplete={true}
          />
          
          {/* 粒子效果 */}
          {showParticles && (
            <View style={styles.particleContainer}>
              <ParticleBurst
                trigger={showParticles}
                count={16}
                duration={800}
                colors={[Colors.primary, Colors.secondary, Colors.accent]}
              />
            </View>
          )}
        </View>

        <Card style={styles.statsCard}>
          <View style={styles.statsRow}>
            <View style={styles.statItem}>
              <Body style={styles.statLabel}>今日专注</Body>
              <Title style={styles.statValue}>0</Title>
            </View>
            <View style={styles.statItem}>
              <Body style={styles.statLabel}>连续天数</Body>
              <Title style={styles.statValue}>0</Title>
            </View>
            <View style={styles.statItem}>
              <Body style={styles.statLabel}>总时长</Body>
              <Title style={styles.statValue}>0h</Title>
            </View>
          </View>
        </Card>

        {sessionNote ? (
          <Card style={styles.noteCard}>
            <Caption style={styles.noteLabel}>上次感受</Caption>
            <Body style={styles.noteText}>{sessionNote}</Body>
          </Card>
        ) : null}
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
  timerContainer: {
    alignItems: 'center',
    marginBottom: Spacing.xl,
    position: 'relative',
  },
  particleContainer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: 'center',
    justifyContent: 'center',
    pointerEvents: 'none',
  },
  statsCard: {
    marginBottom: Spacing.l,
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  statItem: {
    alignItems: 'center',
  },
  statLabel: {
    color: Colors.textSecondary,
    marginBottom: Spacing.xs,
  },
  statValue: {
    color: Colors.primary,
  },
  noteCard: {
    backgroundColor: Colors.surface,
  },
  noteLabel: {
    color: Colors.textSecondary,
    marginBottom: Spacing.s,
  },
  noteText: {
    color: Colors.textPrimary,
    fontStyle: 'italic',
  },
});
