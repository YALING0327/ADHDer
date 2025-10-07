import React, { useEffect, useRef } from 'react';
import { View, Animated, StyleSheet } from 'react-native';
import { Colors } from './colors';

interface ParticleBurstProps {
  trigger: boolean;
  count?: number;
  duration?: number;
  colors?: string[];
  size?: number;
}

interface Particle {
  id: number;
  angle: number;
  distance: number;
  size: number;
  color: string;
  opacity: Animated.Value;
  translateX: Animated.Value;
  translateY: Animated.Value;
}

export const ParticleBurst: React.FC<ParticleBurstProps> = ({
  trigger,
  count = 16,
  duration = 800,
  colors = [Colors.primary, Colors.secondary, Colors.accent],
  size = 120,
}) => {
  const particlesRef = useRef<Particle[]>([]);
  const animationRef = useRef<Animated.CompositeAnimation | null>(null);

  useEffect(() => {
    if (trigger) {
      // 生成粒子
      particlesRef.current = Array.from({ length: count }, (_, i) => {
        const angle = (i / count) * 2 * Math.PI + Math.random() * 0.5;
        const distance = 30 + Math.random() * 40;
        const particleSize = 3 + Math.random() * 4;
        const color = colors[Math.floor(Math.random() * colors.length)];

        return {
          id: i,
          angle,
          distance,
          size: particleSize,
          color,
          opacity: new Animated.Value(1),
          translateX: new Animated.Value(0),
          translateY: new Animated.Value(0),
        };
      });

      // 启动动画
      const animations = particlesRef.current.map(particle => {
        const translateX = particle.distance * Math.cos(particle.angle);
        const translateY = particle.distance * Math.sin(particle.angle);

        return Animated.parallel([
          Animated.timing(particle.opacity, {
            toValue: 0,
            duration,
            useNativeDriver: true,
          }),
          Animated.timing(particle.translateX, {
            toValue: translateX,
            duration,
            useNativeDriver: true,
          }),
          Animated.timing(particle.translateY, {
            toValue: translateY,
            duration,
            useNativeDriver: true,
          }),
        ]);
      });

      animationRef.current = Animated.parallel(animations);
      animationRef.current.start();
    }
  }, [trigger, count, duration, colors]);

  if (!trigger || particlesRef.current.length === 0) {
    return null;
  }

  return (
    <View style={[styles.container, { width: size, height: size }]} pointerEvents="none">
      {particlesRef.current.map(particle => (
        <Animated.View
          key={particle.id}
          style={[
            styles.particle,
            {
              width: particle.size,
              height: particle.size,
              backgroundColor: particle.color,
              opacity: particle.opacity,
              transform: [
                { translateX: particle.translateX },
                { translateY: particle.translateY },
              ],
            },
          ]}
        />
      ))}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    position: 'absolute',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 1000,
  },
  particle: {
    position: 'absolute',
    borderRadius: 50,
  },
});
