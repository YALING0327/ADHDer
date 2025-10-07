import { StatusBar } from 'expo-status-bar';
import React, { useEffect, useMemo, useRef, useState } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { SafeAreaView, Text, View, PanResponder, GestureResponderEvent, PanResponderGestureState, TextInput, TouchableOpacity, FlatList, AppState, AppStateStatus, Image, Linking } from 'react-native';
import { Colors } from './src/ui/colors';
import { Spacing } from './src/ui/spacing';
import { TextStyles } from './src/ui/text';
import { Screen, Card, PrimaryButton, Pill, Title, Caption } from './src/ui/components';
import * as Haptics from 'expo-haptics';
import LoginScreen from './screens/LoginScreen';
import { getToken } from './src/auth';
import { api } from './src/api';

function HomeScreen() {
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: Colors.background }}>
      <View style={{ padding: Spacing.l, gap: Spacing.m }}>
        <Title>首页</Title>
        <Card>
          <Text style={[TextStyles.heading, { color: Colors.text, marginBottom: Spacing.s }]}>今天第一口</Text>
          <PrimaryButton title="开始10分钟任务" onPress={() => {}} />
        </Card>
        <Card>
          <Text style={[TextStyles.heading, { color: Colors.text, marginBottom: Spacing.s }]}>即将到期</Text>
          <Caption>暂无即将到期任务</Caption>
        </Card>
        <Card>
          <Text style={[TextStyles.heading, { color: Colors.text, marginBottom: Spacing.s }]}>专注计时</Text>
          <View style={{ flexDirection: 'row', gap: Spacing.s }}>
            {[25, 45, 60].map((m) => (
              <Pill key={m} title={`${m}m`} onPress={() => {}} />
            ))}
          </View>
        </Card>
      </View>
    </SafeAreaView>
  );
}

function TasksScreen() {
  const [items, setItems] = useState<any[]>([]);
  const [title, setTitle] = useState('');
  const [creating, setCreating] = useState(false);
  const [taskType, setTaskType] = useState<'free' | 'ddl'>('free');
  const [dueDate, setDueDate] = useState('');
  const [showDatePicker, setShowDatePicker] = useState(false);

  const load = async () => {
    try { const res = await api.listTasks(); setItems(res.tasks || []); } catch {}
  };
  useEffect(() => { load(); }, []);

  const create = async () => {
    if (!title.trim()) return;
    setCreating(true);
    try { 
      const due = taskType === 'ddl' && dueDate ? new Date(dueDate).toISOString() : undefined;
      await api.createTask(title.trim(), taskType, due); 
      setTitle(''); 
      setDueDate('');
      load(); 
    } finally { setCreating(false); }
  };

  const formatDate = (dateStr: string) => {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return `${date.getMonth() + 1}/${date.getDate()} ${date.getHours().toString().padStart(2, '0')}:${date.getMinutes().toString().padStart(2, '0')}`;
  };

  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: Colors.background }}>
      <View style={{ padding: Spacing.l }}>
        <Title style={{ marginBottom: Spacing.m }}>待办</Title>
        <View style={{ flexDirection: 'row', marginBottom: Spacing.m, gap: Spacing.s }}>
          <Pill active={taskType==='free'} title="自由任务" onPress={() => setTaskType('free')} />
          <Pill active={taskType==='ddl'} title="DDL任务" onPress={() => setTaskType('ddl')} />
        </View>
        <View style={{ flexDirection: 'row', gap: Spacing.s, alignItems: 'center', marginBottom: Spacing.s }}>
          <TextInput
            value={title}
            onChangeText={setTitle}
            placeholder="输入任务标题"
            style={{ flex: 1, borderWidth: 1, borderColor: Colors.border, borderRadius: 8, padding: 10, backgroundColor: '#fff' }}
          />
          <PrimaryButton title={creating ? '添加中' : '添加'} onPress={create} disabled={creating} />
        </View>
        {taskType === 'ddl' && (
          <View style={{ flexDirection: 'row', gap: Spacing.s, alignItems: 'center' }}>
            <Caption>到期时间:</Caption>
            <TextInput
              value={dueDate}
              onChangeText={setDueDate}
              placeholder="YYYY-MM-DDTHH:mm"
              style={{ flex: 1, borderWidth: 1, borderColor: Colors.border, borderRadius: 8, padding: 10, backgroundColor: '#fff' }}
            />
          </View>
        )}
      </View>
      <FlatList
        data={items}
        keyExtractor={(it) => it.id}
        contentContainerStyle={{ paddingHorizontal: Spacing.l, paddingBottom: 40 }}
        renderItem={({ item }) => (
          <View style={{ paddingVertical: Spacing.m, borderBottomWidth: 1, borderColor: Colors.border }}>
            <View style={{ flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-start' }}>
              <View style={{ flex: 1 }}>
                <Text style={{ fontSize: 16, color: Colors.text }}>{item.title}</Text>
                <Text style={{ fontSize: 12, color: Colors.textSecondary }}>
                  {item.type === 'ddl' ? 'DDL任务' : '自由任务'}
                  {item.due && ` • 到期: ${formatDate(item.due)}`}
                </Text>
              </View>
              {item.type === 'ddl' && item.due && (
                <View style={{
                  paddingHorizontal: 8,
                  paddingVertical: 4,
                  borderRadius: 12,
                  backgroundColor: new Date(item.due) < new Date() ? Colors.warning : Colors.primary,
                }}>
                  <Text style={{ fontSize: 10, color: '#fff' }}>
                    {new Date(item.due) < new Date() ? '已过期' : '进行中'}
                  </Text>
                </View>
              )}
            </View>
          </View>
        )}
        ListEmptyComponent={<Text style={{ paddingHorizontal: Spacing.l, color: Colors.textSecondary }}>暂无任务</Text>}
      />
    </SafeAreaView>
  );
}

function LegalScreen() {
  const base = process.env.EXPO_PUBLIC_API_BASE || 'http://localhost:3000';
  const open = (path: string) => Linking.openURL(base + path).catch(() => {});
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: Colors.background }}>
      <View style={{ padding: Spacing.l, gap: Spacing.m }}>
        <Title>政策</Title>
        <Card>
          <PrimaryButton title="隐私政策" onPress={() => open('/(legal)/privacy')} />
          <View style={{ height: Spacing.s }} />
          <PrimaryButton title="用户协议" onPress={() => open('/(legal)/terms')} />
          <View style={{ height: Spacing.s }} />
          <PrimaryButton title="免责声明" onPress={() => open('/(legal)/disclaimer')} />
        </Card>
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
    <SafeAreaView style={{ flex: 1, backgroundColor: Colors.background }}>
      <View style={{ padding: Spacing.l, gap: Spacing.m }}>
        <Title>专注</Title>
        <View style={{ flexDirection: 'row', gap: Spacing.s }}>
          {[25,45,60].map((m) => (
            <Pill key={m} title={`${m}m`} onPress={() => start(m as 25|45|60)} />
          ))}
        </View>
        <Text style={{ fontSize: 56, fontVariant: ['tabular-nums'], color: Colors.text }}>
          {Math.floor(remaining/60).toString().padStart(2,'0')}:{(remaining%60).toString().padStart(2,'0')}
        </Text>
        {!running ? (
          <PrimaryButton title="继续" onPress={resume} disabled={remaining===0} />
        ) : (
          <PrimaryButton title="暂停" onPress={pause} />
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
    <SafeAreaView style={{ flex: 1, backgroundColor: Colors.background }}>
      <View style={{ padding: 24 }}>
        <Title style={{ marginBottom: Spacing.s }}>想法</Title>
        <Text style={{ fontSize: 18, lineHeight: 24, color: Colors.textSecondary }}>全屏输入/语音（后续） · Inbox</Text>
      </View>
    </SafeAreaView>
  );
}

function SearchScreen() {
  const [q, setQ] = useState('');
  const [res, setRes] = useState<{tasks:any[]; ideas:any[]}>({ tasks: [], ideas: [] });
  const [loading, setLoading] = useState(false);
  const onChange = async (text: string) => {
    setQ(text);
    if (!text.trim()) { setRes({ tasks: [], ideas: [] }); return; }
    setLoading(true);
    try { const r = await api.search(text.trim()); setRes(r); } catch {} finally { setLoading(false); }
  };
  return (
    <SafeAreaView style={{ flex: 1, backgroundColor: Colors.background }}>
      <View style={{ padding: Spacing.l, gap: Spacing.m }}>
        <Title>搜索</Title>
        <TextInput value={q} onChangeText={onChange} placeholder="搜索任务/想法…" style={{ borderWidth: 1, borderColor: Colors.border, borderRadius: 8, padding: 10, backgroundColor: '#fff' }} />
        {loading ? <Caption>搜索中…</Caption> : null}
        <Text style={{ fontSize: 16, fontWeight: '600', color: Colors.text }}>任务</Text>
        {res.tasks.map((t) => (<Text key={t.id}>• {t.title}</Text>))}
        <Text style={{ fontSize: 16, fontWeight: '600', marginTop: Spacing.s, color: Colors.text }}>想法</Text>
        {res.ideas.map((i) => (<Text key={i.id}>• {i.text}</Text>))}
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
    <SafeAreaView style={{ flex: 1, backgroundColor: Colors.background }}>
      <View style={{ padding: Spacing.l, gap: Spacing.m }}>
        <Title>助眠</Title>
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
        <Text style={{ fontSize: 16, color: Colors.textSecondary }}>{Math.floor(remaining/60)}:{(remaining%60).toString().padStart(2,'0')}</Text>
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
    <SafeAreaView style={{ flex: 1, backgroundColor: Colors.background }}>
      <View style={{ padding: Spacing.l, gap: Spacing.m }}>
        <Title>壁纸中心</Title>
        <Image source={{ uri: sample }} style={{ width: '100%', height: 200, borderRadius: 12 }} resizeMode="cover" />
        <PrimaryButton title={saving ? '保存中…' : '保存到相册'} onPress={save} disabled={saving} />
        <Caption>iOS：相册→设为壁纸；Android：相册中选择图片→设为壁纸。</Caption>
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
        <Tab.Screen name="搜索" component={SearchScreen} />
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


