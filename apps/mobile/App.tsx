import { StatusBar } from 'expo-status-bar';
import React, { useEffect, useMemo, useRef, useState } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { SafeAreaView, Text, View, PanResponder, GestureResponderEvent, PanResponderGestureState, TextInput, TouchableOpacity, FlatList, AppState, AppStateStatus, Image, Linking } from 'react-native';
import * as Haptics from 'expo-haptics';
import LoginScreen from './screens/LoginScreen';
import { getToken } from './src/auth';
import { api } from './src/api';

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
  const [items, setItems] = useState<any[]>([]);
  const [title, setTitle] = useState('');
  const [creating, setCreating] = useState(false);

  const load = async () => {
    try { const res = await api.listTasks(); setItems(res.tasks || []); } catch {}
  };
  useEffect(() => { load(); }, []);

  const create = async () => {
    if (!title.trim()) return;
    setCreating(true);
    try { await api.createTask(title.trim(), 'free'); setTitle(''); load(); } finally { setCreating(false); }
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24 }}>
        <Text style={{ fontSize: 28, fontWeight: '600', marginBottom: 12 }}>待办</Text>
        <View style={{ flexDirection: 'row', gap: 8, alignItems: 'center' }}>
          <TextInput value={title} onChangeText={setTitle} placeholder="输入任务标题" style={{ flex: 1, borderWidth: 1, borderColor: '#ddd', borderRadius: 8, padding: 10 }} />
          <TouchableOpacity onPress={create} disabled={creating} style={{ backgroundColor: '#4b8', paddingVertical: 10, paddingHorizontal: 14, borderRadius: 8 }}>
            <Text style={{ color: '#fff' }}>{creating ? '添加中' : '添加'}</Text>
          </TouchableOpacity>
        </View>
      </View>
      <FlatList
        data={items}
        keyExtractor={(it) => it.id}
        contentContainerStyle={{ paddingHorizontal: 24, paddingBottom: 40 }}
        renderItem={({ item }) => (
          <View style={{ paddingVertical: 12, borderBottomWidth: 1, borderColor: '#eee' }}>
            <Text style={{ fontSize: 16 }}>{item.title}</Text>
            <Text style={{ fontSize: 12, color: '#666' }}>{item.type}</Text>
          </View>
        )}
        ListEmptyComponent={<Text style={{ paddingHorizontal: 24, color: '#666' }}>暂无任务</Text>}
      />
    </SafeAreaView>
  );
}

function LegalScreen() {
  const base = process.env.EXPO_PUBLIC_API_BASE || 'http://localhost:3000';
  const open = (path: string) => Linking.openURL(base + path).catch(() => {});
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24, gap: 12 }}>
        <Text style={{ fontSize: 28, fontWeight: '600' }}>政策</Text>
        <TouchableOpacity onPress={() => open('/(legal)/privacy')} style={{ padding: 12, borderRadius: 10, borderWidth: 1, borderColor: '#ddd' }}>
          <Text>隐私政策</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => open('/(legal)/terms')} style={{ padding: 12, borderRadius: 10, borderWidth: 1, borderColor: '#ddd' }}>
          <Text>用户协议</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={() => open('/(legal)/disclaimer')} style={{ padding: 12, borderRadius: 10, borderWidth: 1, borderColor: '#ddd' }}>
          <Text>免责声明</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

function FocusScreen() {
  const [mode, setMode] = useState<25|45|60>(25);
  const [remaining, setRemaining] = useState(0);
  const [running, setRunning] = useState(false);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [interrupts, setInterrupts] = useState(0);
  const startedAtRef = useRef<number>(0);
  const appStateRef = useRef<AppStateStatus>(AppState.currentState);

  useEffect(() => {
    const sub = AppState.addEventListener('change', (next) => {
      const prev = appStateRef.current; appStateRef.current = next;
      if (running) {
        // 校正：根据真实时间差修正剩余时间
        const now = Date.now();
        const elapsed = Math.floor((now - startedAtRef.current) / 1000);
        const total = mode * 60;
        setRemaining(Math.max(0, total - elapsed));
      }
      if (prev === 'active' && next.match(/inactive|background/)) {
        setInterrupts((n) => n + 1);
      }
    });
    return () => sub.remove();
  }, [running, mode]);

  useEffect(() => {
    let timer: any;
    if (running) {
      timer = setInterval(() => {
        setRemaining((r) => {
          if (r <= 1) {
            clearInterval(timer);
            setRunning(false);
            if (sessionId) {
              // 结束写入后端
              fetch((process.env.EXPO_PUBLIC_API_BASE || 'http://localhost:3000') + '/api/focus-sessions', {
                method: 'POST', headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ mode, end: new Date().toISOString(), interrupts })
              }).catch(() => {});
            }
            return 0;
          }
          return r - 1;
        });
      }, 1000);
    }
    return () => timer && clearInterval(timer);
  }, [running, mode, sessionId, interrupts]);

  const start = async (m: 25|45|60) => {
    setMode(m);
    const total = m * 60;
    setRemaining(total);
    setRunning(true);
    startedAtRef.current = Date.now();
    try {
      const base = process.env.EXPO_PUBLIC_API_BASE || 'http://localhost:3000';
      const res = await fetch(base + '/api/focus-sessions', { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ mode: m, start: new Date().toISOString(), interrupts: 0 }) });
      const json = await res.json();
      setSessionId(json.item?.id || null);
    } catch {}
  };

  const pause = () => { setRunning(false); };
  const resume = () => { setRunning(true); startedAtRef.current = Date.now() - ((mode*60 - remaining) * 1000); };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24, gap: 12 }}>
        <Text style={{ fontSize: 28, fontWeight: '600' }}>专注</Text>
        <View style={{ flexDirection: 'row', gap: 8 }}>
          {[25,45,60].map((m) => (
            <TouchableOpacity key={m} onPress={() => start(m as 25|45|60)} style={{ backgroundColor: '#222', paddingVertical: 8, paddingHorizontal: 14, borderRadius: 8 }}>
              <Text style={{ color: '#fff' }}>{m}m</Text>
            </TouchableOpacity>
          ))}
        </View>
        <Text style={{ fontSize: 48, fontVariant: ['tabular-nums'] }}>{Math.floor(remaining/60).toString().padStart(2,'0')}:{(remaining%60).toString().padStart(2,'0')}</Text>
        {!running ? (
          <TouchableOpacity onPress={resume} disabled={remaining===0} style={{ backgroundColor: '#48f', padding: 12, borderRadius: 10 }}>
            <Text style={{ color: '#fff', textAlign: 'center' }}>继续</Text>
          </TouchableOpacity>
        ) : (
          <TouchableOpacity onPress={pause} style={{ backgroundColor: '#f84', padding: 12, borderRadius: 10 }}>
            <Text style={{ color: '#fff', textAlign: 'center' }}>暂停</Text>
          </TouchableOpacity>
        )}
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

import { Audio } from 'expo-av';
import * as MediaLibrary from 'expo-media-library';
import * as FileSystem from 'expo-file-system';
function SleepScreen() {
  const [sound, setSound] = useState<Audio.Sound | null>(null);
  const [playing, setPlaying] = useState(false);
  const [timer, setTimer] = useState<15|30|60|120>(30);
  const [remaining, setRemaining] = useState(0);

  const loadAndPlay = async (uri: string) => {
    if (sound) { await sound.unloadAsync(); setSound(null); }
    const { sound: s } = await Audio.Sound.createAsync({ uri }, { isLooping: true, volume: 1.0 });
    setSound(s);
    await s.playAsync();
    setPlaying(true);
    setRemaining(timer*60);
  };

  useEffect(() => {
    let id: any;
    if (playing && remaining > 0) {
      id = setInterval(async () => {
        setRemaining((r) => {
          if (r <= 1) {
            // 渐隐
            (async () => {
              if (sound) {
                for (let v = 1.0; v >= 0; v -= 0.1) { await sound.setVolumeAsync(Math.max(0, v)); await new Promise(r => setTimeout(r, 200)); }
                await sound.stopAsync();
              }
            })();
            setPlaying(false);
            return 0;
          }
          return r - 1;
        });
      }, 1000);
    }
    return () => id && clearInterval(id);
  }, [playing, remaining, sound]);

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24, gap: 12 }}>
        <Text style={{ fontSize: 28, fontWeight: '600' }}>助眠</Text>
        <View style={{ flexDirection: 'row', gap: 8, flexWrap: 'wrap' }}>
          <TouchableOpacity onPress={() => loadAndPlay('https://cdn.freesound.org/previews/415/415209_5121236-lq.mp3')} style={{ backgroundColor: '#222', padding: 10, borderRadius: 8 }}><Text style={{ color: '#fff' }}>白噪</Text></TouchableOpacity>
          <TouchableOpacity onPress={() => loadAndPlay('https://cdn.freesound.org/previews/384/384468_2255158-lq.mp3')} style={{ backgroundColor: '#222', padding: 10, borderRadius: 8 }}><Text style={{ color: '#fff' }}>自然</Text></TouchableOpacity>
          <TouchableOpacity onPress={() => loadAndPlay('https://cdn.freesound.org/previews/344/344761_230527-lq.mp3')} style={{ backgroundColor: '#222', padding: 10, borderRadius: 8 }}><Text style={{ color: '#fff' }}>Lo‑fi</Text></TouchableOpacity>
        </View>
        <View style={{ flexDirection: 'row', gap: 8 }}>
          {[15,30,60,120].map((t) => (
            <TouchableOpacity key={t} onPress={() => setTimer(t as 15|30|60|120)} style={{ padding: 8, borderRadius: 8, borderWidth: 1, borderColor: '#ccc' }}>
              <Text>{t}m</Text>
            </TouchableOpacity>
          ))}
        </View>
        <Text style={{ fontSize: 16, color: '#666' }}>{Math.floor(remaining/60)}:{(remaining%60).toString().padStart(2,'0')}</Text>
      </View>
    </SafeAreaView>
  );
}

async function ensureMediaPermissions() {
  const { status } = await MediaLibrary.requestPermissionsAsync();
  if (status !== 'granted') throw new Error('权限未授予');
}

function WallpaperScreen() {
  const sample = 'https://images.unsplash.com/photo-1517816428104-797678c7cf0d?q=80&w=1200&auto=format&fit=crop';
  const [saving, setSaving] = React.useState(false);
  const save = async () => {
    try {
      setSaving(true);
      await ensureMediaPermissions();
      const fileUri = FileSystem.cacheDirectory + 'adhder_wallpaper.jpg';
      const { uri } = await FileSystem.downloadAsync(sample, fileUri);
      await MediaLibrary.saveToLibraryAsync(uri);
      alert('已保存到相册。iOS：前往设置壁纸；Android：可在相册中设为壁纸。');
    } catch (e:any) {
      alert('保存失败：' + e.message);
    } finally { setSaving(false); }
  };
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: '#fff' }}>
      <View style={{ padding: 24, gap: 12 }}>
        <Text style={{ fontSize: 28, fontWeight: '600' }}>壁纸中心</Text>
        <Image source={{ uri: sample }} style={{ width: '100%', height: 200, borderRadius: 12 }} resizeMode="cover" />
        <TouchableOpacity onPress={save} disabled={saving} style={{ backgroundColor: '#222', padding: 12, borderRadius: 10 }}>
          <Text style={{ color: '#fff', textAlign: 'center' }}>{saving ? '保存中…' : '保存到相册'}</Text>
        </TouchableOpacity>
        <Text style={{ color: '#666' }}>iOS：相册→设为壁纸；Android：相册中选择图片→设为壁纸。</Text>
      </View>
    </SafeAreaView>
  );
}

const Tab = createBottomTabNavigator();

export default function App() {
  const [isAuthed, setAuthed] = useState<boolean | null>(null);
  useEffect(() => { (async () => { const t = await getToken(); setAuthed(!!t); })(); }, []);
  if (isAuthed === null) return null;
  return (
    <NavigationContainer>
      {isAuthed ? (
        <Tab.Navigator screenOptions={{ headerShown: false }}>
          <Tab.Screen name="首页" component={HomeScreen} />
          <Tab.Screen name="待办" component={TasksScreen} />
          <Tab.Screen name="专注" component={FocusScreen} />
          <Tab.Screen name="佛珠" component={FidgetScreen} />
          <Tab.Screen name="想法" component={IdeasScreen} />
        <Tab.Screen name="助眠" component={SleepScreen} />
        <Tab.Screen name="壁纸" component={WallpaperScreen} />
        <Tab.Screen name="政策" component={LegalScreen} />
        </Tab.Navigator>
      ) : (
        <LoginScreen onLoggedIn={() => setAuthed(true)} />
      )}
      <StatusBar style="auto" />
    </NavigationContainer>
  );
}


