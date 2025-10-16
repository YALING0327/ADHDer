<template>
  <div class="wechat-login">
    <!-- 微信登录按钮 -->
    <button 
      v-if="!isLoading"
      @click="handleWeChatLogin" 
      class="wechat-login-btn"
    >
      <svg class="wechat-icon" viewBox="0 0 24 24">
        <path fill="currentColor" d="M9.5 4C5.36 4 2 6.69 2 10c0 1.89 1.08 3.56 2.78 4.66L4 17l2.5-1.5c.89.31 1.87.5 2.91.5.33 0 .66-.03.98-.08A5.5 5.5 0 0 0 15 11.5a5.5 5.5 0 0 0-5.5-5.5m-2 7.5a1 1 0 0 1-1-1a1 1 0 0 1 1-1a1 1 0 0 1 1 1a1 1 0 0 1-1 1m4 0a1 1 0 0 1-1-1a1 1 0 0 1 1-1a1 1 0 0 1 1 1a1 1 0 0 1-1 1m6.5-3.5c-3.04 0-5.5 2.24-5.5 5s2.46 5 5.5 5c.83 0 1.62-.17 2.34-.47L23 19l-.72-2.14C23.39 15.96 24 14.6 24 13c0-2.76-2.46-5-5.5-5m-2.5 6.5a1 1 0 0 1-1-1a1 1 0 0 1 1-1a1 1 0 0 1 1 1a1 1 0 0 1-1 1m3 0a1 1 0 0 1-1-1a1 1 0 0 1 1-1a1 1 0 0 1 1 1a1 1 0 0 1-1 1z"/>
      </svg>
      微信登录
    </button>

    <!-- 加载状态 -->
    <div v-else class="loading">
      <div class="spinner"></div>
      <p>正在登录...</p>
    </div>

    <!-- 绑定手机号弹窗 -->
    <div v-if="showBindPhone" class="bind-phone-modal">
      <div class="modal-content">
        <h3>绑定手机号</h3>
        <p class="tip">为了您的账号安全，请绑定手机号</p>
        
        <div class="form-group">
          <input
            v-model="phone"
            type="tel"
            placeholder="请输入手机号"
            maxlength="11"
            @input="validatePhone"
          />
          <span v-if="phoneError" class="error">{{ phoneError }}</span>
        </div>

        <div class="form-group code-group">
          <input
            v-model="code"
            type="text"
            placeholder="请输入验证码"
            maxlength="6"
          />
          <button
            :disabled="!canSendCode || countdown > 0"
            @click="sendCode"
            class="send-code-btn"
          >
            {{ countdown > 0 ? `${countdown}秒后重试` : '发送验证码' }}
          </button>
        </div>

        <button
          :disabled="!canBind"
          @click="bindPhone"
          class="bind-btn"
        >
          绑定并完成登录
        </button>

        <p class="skip-tip" @click="skipBind">暂不绑定，直接登录</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'WeChatLogin',
  data() {
    return {
      isLoading: false,
      showBindPhone: false,
      tempToken: null,
      tempUserId: null,
      phone: '',
      code: '',
      phoneError: '',
      countdown: 0,
      timer: null
    };
  },
  computed: {
    canSendCode() {
      return /^1[3-9]\d{9}$/.test(this.phone) && !this.phoneError;
    },
    canBind() {
      return this.canSendCode && this.code.length === 6;
    }
  },
  methods: {
    // 微信登录
    handleWeChatLogin() {
      // 检查环境
      if (!this.isWeChatBrowser() && !this.isInApp()) {
        this.$message.warning('请在微信或APP内打开');
        return;
      }

      // 获取微信授权
      this.getWeChatAuthCode();
    },

    // 判断是否在微信浏览器
    isWeChatBrowser() {
      const ua = navigator.userAgent.toLowerCase();
      return /micromessenger/.test(ua);
    },

    // 判断是否在APP内
    isInApp() {
      // 根据实际情况判断，例如检查特定的 UserAgent 或 window 对象
      return window.isAdhderApp === true;
    },

    // 获取微信授权码
    getWeChatAuthCode() {
      const appId = process.env.VUE_APP_WECHAT_APP_ID || 'YOUR_WECHAT_APP_ID';
      const redirectUri = encodeURIComponent(window.location.href);
      const state = Math.random().toString(36).substring(7);
      
      // 保存state用于验证
      sessionStorage.setItem('wechat_state', state);

      // 跳转到微信授权页面
      const authUrl = `https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appId}&redirect_uri=${redirectUri}&response_type=code&scope=snsapi_userinfo&state=${state}#wechat_redirect`;
      
      window.location.href = authUrl;
    },

    // 处理微信回调
    async handleWeChatCallback() {
      const urlParams = new URLSearchParams(window.location.search);
      const code = urlParams.get('code');
      const state = urlParams.get('state');
      
      if (!code) return;

      // 验证state
      const savedState = sessionStorage.getItem('wechat_state');
      if (state !== savedState) {
        this.$message.error('登录验证失败，请重试');
        return;
      }

      this.isLoading = true;

      try {
        // 调用后端接口
        const response = await axios.post('/api/v3/auth/wechat/login', { code });

        if (response.data.success) {
          const { token, user, needBindPhone, isNewUser } = response.data;

          if (needBindPhone) {
            // 需要绑定手机号
            this.tempToken = token;
            this.tempUserId = user._id;
            this.showBindPhone = true;
            this.isLoading = false;
            
            if (isNewUser) {
              this.$message.info('欢迎注册ADHDER！请绑定手机号');
            } else {
              this.$message.info('请绑定手机号以提升账号安全性');
            }
          } else {
            // 直接登录成功
            this.loginSuccess(token, user);
          }
        }
      } catch (err) {
        this.isLoading = false;
        this.$message.error(err.response?.data?.message || '登录失败');
      }
    },

    // 验证手机号
    validatePhone() {
      this.phone = this.phone.replace(/\D/g, '');
      
      if (!this.phone) {
        this.phoneError = '';
      } else if (!/^1[3-9]\d{9}$/.test(this.phone)) {
        this.phoneError = '请输入正确的手机号';
      } else {
        this.phoneError = '';
      }
    },

    // 发送验证码
    async sendCode() {
      if (!this.canSendCode) return;

      try {
        const response = await axios.post('/api/v3/auth/phone/send-code', {
          phone: this.phone
        });

        if (response.data.success) {
          this.$message.success('验证码已发送');
          
          // 开发环境显示验证码
          if (response.data.code) {
            this.$message.info(`验证码: ${response.data.code}`);
          }

          // 开始倒计时
          this.countdown = 60;
          this.timer = setInterval(() => {
            this.countdown--;
            if (this.countdown <= 0) {
              clearInterval(this.timer);
            }
          }, 1000);
        }
      } catch (err) {
        this.$message.error(err.response?.data?.message || '发送失败');
      }
    },

    // 绑定手机号
    async bindPhone() {
      if (!this.canBind) return;

      try {
        const response = await axios.post(
          '/api/v3/auth/phone/bind',
          {
            phone: this.phone,
            code: this.code
          },
          {
            headers: {
              'x-api-key': this.tempToken
            }
          }
        );

        if (response.data.success) {
          this.$message.success('绑定成功');
          this.loginSuccess(this.tempToken, { _id: this.tempUserId });
        }
      } catch (err) {
        this.$message.error(err.response?.data?.message || '绑定失败');
      }
    },

    // 跳过绑定
    skipBind() {
      this.$message.info('建议尽快绑定手机号');
      this.loginSuccess(this.tempToken, { _id: this.tempUserId });
    },

    // 登录成功
    loginSuccess(token, user) {
      // 保存token
      localStorage.setItem('token', token);
      localStorage.setItem('userId', user._id);
      
      // 保存用户信息到Vuex
      this.$store.commit('setUser', user);

      // 跳转首页
      this.$router.push('/');
      
      this.$message.success('登录成功');
    }
  },
  mounted() {
    // 检查是否是微信回调
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('code')) {
      this.handleWeChatCallback();
    }
  },
  beforeDestroy() {
    if (this.timer) {
      clearInterval(this.timer);
    }
  }
};
</script>

<style scoped>
.wechat-login {
  width: 100%;
}

.wechat-login-btn {
  width: 100%;
  padding: 14px;
  background: #07C160;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  transition: background 0.3s;
}

.wechat-login-btn:hover {
  background: #06AD56;
}

.wechat-icon {
  width: 24px;
  height: 24px;
}

.loading {
  text-align: center;
  padding: 20px;
}

.spinner {
  width: 40px;
  height: 40px;
  margin: 0 auto 10px;
  border: 3px solid #f3f3f3;
  border-top: 3px solid #07C160;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 绑定手机号弹窗 */
.bind-phone-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
}

.modal-content {
  background: white;
  padding: 30px;
  border-radius: 8px;
  width: 90%;
  max-width: 400px;
}

.modal-content h3 {
  margin: 0 0 10px;
  text-align: center;
}

.tip {
  text-align: center;
  color: #666;
  margin-bottom: 20px;
}

.form-group {
  margin-bottom: 15px;
}

input {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
  box-sizing: border-box;
}

.code-group {
  display: flex;
  gap: 10px;
}

.code-group input {
  flex: 1;
}

.send-code-btn {
  padding: 12px 20px;
  background: #07C160;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  white-space: nowrap;
}

.send-code-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.bind-btn {
  width: 100%;
  padding: 14px;
  background: #2196F3;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
}

.bind-btn:disabled {
  background: #ccc;
  cursor: not-allowed;
}

.skip-tip {
  text-align: center;
  color: #999;
  font-size: 14px;
  margin-top: 15px;
  cursor: pointer;
}

.skip-tip:hover {
  color: #666;
}

.error {
  color: #f44336;
  font-size: 12px;
  margin-top: 5px;
  display: block;
}
</style>

