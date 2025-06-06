<template>
  <div class="login-container">
    <div class="content">
      <img class="leftImg" src="~@/assets/login/left.png" alt="">
      <el-form class="login-form" autoComplete="on" :model="loginForm" :rules="loginRules" ref="loginForm"
        label-position="left">
        <h3 class="title">OpenAuth.Net Vue2版</h3>
        <p class="tips">powered by vue2/element-ui</p>
        <el-form-item prop="username">

          <el-input suffix-icon="iconfont icon-yonghu_zhanghao_wode" name="username" type="text"
            v-model="loginForm.username" autoComplete="on" placeholder="请输入登录账号" />
        </el-form-item>
        <el-form-item prop="password">

          <el-input name="password" :type="pwdType" v-model="loginForm.password"
            autoComplete="on" placeholder="请输入密码"></el-input>

          <span @click="showPwd" style="position: absolute;top:16px;right:33px;"
            :class="pwdType === 'password' ? 'icon iconfont icon-xianshi_chakan' : 'icon iconfont icon-yincang'"></span>

        </el-form-item>
        <el-form-item prop="code">

          <el-input name="code" @keyup.enter.native="handleLogin" v-model="loginForm.code"
            autoComplete="off" placeholder="请输入验证码">
          </el-input>
          <identify v-model="identifyCode" class="imgCode"></identify>
        </el-form-item>

        <el-form-item prop="tenantid">
          <span class="icon iconfont icon-yonghuguanli"></span>
          <el-select v-model="tenant" placeholder="请选择" @change="tenantChange">
            <el-option v-for="item in tenants" :key="item.value" :label="item.label" :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>

        <div class="tips" v-if="isIdentityAuth">
          <router-link to="/oidcRedirect">
            <el-badge is-dot>接口服务器启用了Oauth认证，请点击这里登录</el-badge>
          </router-link>
        </div>
        <el-form-item v-else>
          <el-button v-waves type="primary" style="width:100%;background:#4452D5;font-size: 24px;height: 50px;"
            :loading="loading" @click.native.prevent="handleLogin">
            登 录
          </el-button>
        </el-form-item>
        <p class="tips"> 默认System登录后，你可以无法无天</p>
        <p class="tips">admin/admin登录后，会少一点权限，资源管理/分类管理的字段会少一点</p>
        <p class="tips">test/test登录后，权限会更少,资源管理/分类管理的字段也更少</p>
      </el-form>
    </div>

  </div>
</template>

<script>
  import waves from '@/directive/waves' // 水波纹指令
  import identify from '@/components/ImgVerify'
  import {
    mapGetters,
    mapActions
  } from 'vuex'
  export default {
    name: 'login',
    components: {
      identify
    },
    directives: {
      waves
    },
    data() {
      const validateUsername = (rule, value, callback) => {
        if (value.length <= 0) {
          callback(new Error('用户名不能为空'))
        } else {
          callback()
        }
      }
      const validatePass = (rule, value, callback) => {
        if (value.length <= 0) {
          callback(new Error('密码不能为空'))
        } else {
          callback()
        }
      }
      const validcode = (rule, value, callback) => {
        console.log('value', value)
        if (!value) {
          callback(new Error('验证码不能为空'))
        } else if (value.toLowerCase() !== this.identifyCode.toLowerCase()) {
          callback(new Error('验证码不正确'))
        } else {
          callback()
        }
      }
      return {
        tenant: this.tenantid || 'OpenAuthDBContext', //当前选择的租户
        tenants: [{
          value: 'OpenAuthDBContext',
          label: '默认租户'
        }, {
          value: 'ErrorId404',
          label: '模拟一个不存在的租户'
        }],
        loginForm: {
          username: 'System',
          password: '123456',
        code: ''
        },
        loginRules: {
          username: [{
            required: true,
            trigger: 'blur',
            validator: validateUsername
          }],
          password: [{
            required: true,
            trigger: 'blur',
            validator: validatePass
          }],
          code: [{
            required: true,
            trigger: 'blur',
            validator: validcode
          }]
        },
        loading: false,
        pwdType: 'password',
        identifyCode: ''
      }
    },
    computed: {
      ...mapGetters([
        'isIdentityAuth',
        'tenantid',
      ])
    },
    methods: {
      ...mapActions([
        'setTenantId', //
      ]),

      tenantChange(e) {
        this.setTenantId(e)
      },
      showPwd() {
        if (this.pwdType === 'password') {
          this.pwdType = ''
        } else {
          this.pwdType = 'password'
        }
      },
      handleLogin() {
        this.$refs.loginForm.validate(valid => {
          if (valid) {
            this.loading = true
            this.$store.dispatch('Login', this.loginForm).then(() => {
              this.loading = false
              this.$router.push({
                path: '/'
              })
            }).catch(() => {
              this.loading = false
            })
          } else {
            console.log('error submit!!')
            return false
          }
        })
      },
      // 修改验证码
      changeCode(val) {
        this.identifyCode = val
      }
    }
  }
</script>

<style rel="stylesheet/scss" lang="scss">
  $bg:#2d3a4b;
  $light_gray:#eee;
  $color_balck: #333;

  /* reset element-ui css */
  .login-container {
    .el-input {
      display: inline-block;
      height: 47px;
      width: 85%;

      input {
        background: transparent;
        border: 0px;
        -webkit-appearance: none;
        border-radius: 0px;
        padding: 12px 5px 12px 15px;
        color: $color_balck;
        height: 47px;

        &:-webkit-autofill {
          transition: background-color 5000s ease-in-out 0s;
        }
      }
    }

    .el-form-item {
      margin-bottom: 35px;
      border-radius: 5px;
      color: #454545;

      .el-form-item__content {
        background: #fff;
        border: 1px solid rgba(223, 223, 223, 1);
      }
      .imgCode{
        position: absolute;
        top: 4px;
        right: 4px;
      }

      &:last-child {
        padding-top: 20px;

        .el-form-item__content {
          border: none;
        }
      }
    }
  }
</style>

<style rel="stylesheet/scss" lang="scss" scoped>
  @media screen and (max-width: 1150px) {
    .leftImg {
      width: 450px !important;
    }
  }

  @media screen and (max-width: 1010px) {
    .leftImg {
      width: 380px !important;
    }
  }

  @media screen and (max-width: 940px) {
    .leftImg {
      display: block;
      width: 260px !important;
      margin: 0 auto !important;
    }
  }

  $dark_gray:#D1DFE8;

  .login-container {
    height: 100%;
    background: url('~@/assets/login/bg.png') no-repeat;
    background-color: #EBEBEA;
    background-position: 0 0;
    background-size: 62% 100%;
    text-align: center;

    &:before {
      content: '';
      display: inline-block;
      height: 100%;
      vertical-align: middle;
    }

    .content {
      display: inline-block;
      vertical-align: middle;

      >img {
        width: 568px;
        margin-right: 150px;
        vertical-align: middle;
      }

      .login-form {
        display: inline-block;
        width: 400px;
        vertical-align: middle;
      }
    }

    .svg-container {
      color: $dark_gray;
      vertical-align: middle;
      width: 33px;
      display: inline-block;
      font-size: 22px;

      &_login {
        font-size: 31px;
      }
    }

    .title {
      font-size: 26px;
      font-weight: 400;
      color: #4452D5;
      margin: 0;
      text-align: left;
    }

    .tips {
      color: #959595;
      font-size: 14px;
      margin-top: 0;
      margin-bottom: 40px;
      text-align: left;
    }

    .show-pwd {
      position: absolute;
      right: 10px;
      top: 7px;
      font-size: 16px;
      color: $dark_gray;
      cursor: pointer;
      user-select: none;
      font-size: 24px;
    }
  }
</style>