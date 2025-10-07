import React, { useState, useEffect, useRef } from 'react';
import { View, Text, TouchableOpacity, StyleSheet, Animated } from 'react-native';
import * as Haptics from 'expo-haptics';
import { Colors } from './colors';
import { Spacing } from './spacing';
import { TimerText, Caption } from './text';

interface FocusTimerRingProps {
  durationSeconds?: number;
  autostart?: boolean;
  onComplete?: () => void;
  onTick?: (remaining: number) => void;
  vibrateOnTick?: boolean;
  vibrateOnComplete?: boolean;
}

export const FocusTimerRing: React.FC<FocusTimerRingProps> = ({
  durationSeconds = 1500, // 25 minutes
  autostart = false,
  onComplete,
  onTick,
  vibrateOnTick = false,
  vibrateOnComplete = true,
}) => {
  const [remaining, setRemaining] = useState(durationSeconds);
  const [isRunning, setIsRunning] = useState(autostart);
  const [isCompleted, setIsCompleted] = useState(false);
  const intervalRef = useRef<NodeJS.Timeout | null>(null);
  const progressAnim = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    if (isRunning && remaining > 0) {
      intervalRef.current = setInterval(() => {
        setRemaining(prev => {
          const newRemaining = prev - 1;
          if (newRemaining <= 0) {
            setIsRunning(false);
            setIsCompleted(true);
            if (vibrateOnComplete) {
              Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Heavy);
            }
            onComplete?.();
            return 0;
          }
          
          // 每分钟震动一次
          if (vibrateOnTick && newRemaining % 60 === 0 && newRemaining !== 0) {
            Haptics.selectionAsync();
          }
          
          onTick?.(newRemaining);
          return newRemaining;
        });
      }, 1000);
    } else {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
        intervalRef.current = null;
      }
    }

    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, [isRunning, remaining, vibrateOnTick, vibrateOnComplete, onComplete, onTick]);

  // 更新进度动画
  useEffect(() => {
    const progress = 1 - (remaining / durationSeconds);
    Animated.timing(progressAnim, {
      toValue: progress,
      duration: 200,
      useNativeDriver: false,
    }).start();
  }, [remaining, durationSeconds, progressAnim]);

  const start = () => {
    setIsRunning(true);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
  };

  const pause = () => {
    setIsRunning(false);
    Haptics.selectionAsync();
  };

  const reset = () => {
    setIsRunning(false);
    setIsCompleted(false);
    setRemaining(durationSeconds);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
  };

  const formatTime = (seconds: number) => {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
  };

  const progress = 1 - (remaining / durationSeconds);
  const circumference = 2 * Math.PI * 90; // 半径90
  const strokeDashoffset = circumference * (1 - progress);

  return (
    <View style={styles.container}>
      <View style={styles.ringContainer}>
        {/* 背景圆环 */}
        <View style={styles.backgroundRing} />
        
        {/* 进度圆环 */}
        <View style={[styles.progressRing, { 
          transform: [{ rotate: '-90deg' }],
          borderTopColor: isCompleted ? Colors.success : Colors.primary,
          borderRightColor: progress > 0.25 ? (isCompleted ? Colors.success : Colors.primary) : 'transparent',
          borderBottomColor: progress > 0.5 ? (isCompleted ? Colors.success : Colors.primary) : 'transparent',
          borderLeftColor: progress > 0.75 ? (isCompleted ? Colors.success : Colors.primary) : 'transparent',
        }]} />
        
        {/* 中心内容 */}
        <View style={styles.centerContent}>
          <TimerText style={[styles.timerText, { 
            color: isCompleted ? Colors.success : Colors.textPrimary 
          }]}>
            {formatTime(remaining)}
          </TimerText>
          <Caption style={styles.instructionText}>
            {isCompleted ? '完成！' : isRunning ? '暂停 · 长按重置' : '点击开始'}
          </Caption>
        </View>
      </View>

      {/* 控制按钮 */}
      <TouchableOpacity
        style={[styles.controlButton, { 
          backgroundColor: isCompleted ? Colors.success : Colors.primary 
        }]}
        onPress={isRunning ? pause : start}
        onLongPress={reset}
        activeOpacity={0.8}
      >
        <Text style={styles.controlButtonText}>
          {isRunning ? '暂停' : isCompleted ? '重新开始' : '开始'}
        </Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    justifyContent: 'center',
    padding: Spacing.l,
  },
  ringContainer: {
    width: 220,
    height: 220,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: Spacing.l,
  },
  backgroundRing: {
    position: 'absolute',
    width: 200,
    height: 200,
    borderRadius: 100,
    borderWidth: 8,
    borderColor: Colors.border,
  },
  progressRing: {
    position: 'absolute',
    width: 200,
    height: 200,
    borderRadius: 100,
    borderWidth: 8,
    borderColor: 'transparent',
  },
  centerContent: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  timerText: {
    marginBottom: Spacing.s,
  },
  instructionText: {
    textAlign: 'center',
  },
  controlButton: {
    paddingHorizontal: Spacing.xl,
    paddingVertical: Spacing.m,
    borderRadius: 12,
    minHeight: Spacing.buttonHeight,
    justifyContent: 'center',
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 2,
  },
  controlButtonText: {
    color: Colors.backgroundElevated,
    fontSize: 16,
    fontWeight: '600',
  },
});
