<!--
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2022-05-12 23:34:24
 * @LastEditTime: 2023-08-16 22:28:43
 * @Description: 图形验证码
 * @
 * @Copyright (c) 2023 by yubaolee | ahfu~ , All Rights Reserved. 
-->

<template>
  <div class="s-canvas" @click="changeCode" style="cursor: pointer;">
    <canvas id="s-canvas" :width="contentWidth" :height="contentHeight"></canvas>
  </div>
</template>
<script>
export default {
  name: 'SIdentify',
  props: {
    value: { // 条形码生成后回传父组件
      type: String,
      default: ''
    },
    fontSizeMin: { // 字体最小值
      type: Number,
      default: 25
    },
    fontSizeMax: { // 字体最大值
      type: Number,
      default: 35
    },
    backgroundColorMin: { // 验证码图片背景色最小值
      type: Number,
      default: 200
    },
    backgroundColorMax: { // 验证码图片背景色最大值
      type: Number,
      default: 220
    },
    dotColorMin: { // 背景干扰点最小值
      type: Number,
      default: 60
    },
    dotColorMax: { // 背景干扰点最大值
      type: Number,
      default: 120
    },
    contentWidth: { // 容器宽度
      type: Number,
      default: 116
    },
    contentHeight: { // 容器高度
      type: Number,
      default: 39
    }
  },
  data() {
      return {
          identifyCode: '', // 图形文字
          identifyCodes: '123456789abcdefghijkmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ' // 图形数据范围,去掉Ool0等易误导的字符
      }
  },
  methods: {
    // 生成一个随机数
    randomNum (min, max) {
      return Math.floor(Math.random() * (max - min) + min)
    },
    // 生成一个随机的颜色
    randomColor (min, max) {
      let r = this.randomNum(min, max)
      let g = this.randomNum(min, max)
      let b = this.randomNum(min, max)
      return 'rgb(' + r + ',' + g + ',' + b + ')'
    },
    drawPic () {
      let canvas = document.getElementById('s-canvas')
      let ctx = canvas.getContext('2d')
      ctx.textBaseline = 'bottom'
      // 绘制背景
      ctx.fillStyle = this.randomColor(this.backgroundColorMin, this.backgroundColorMax)
      ctx.fillRect(0, 0, this.contentWidth, this.contentHeight)
      // 绘制文字
      for (let i = 0; i < this.identifyCode.length; i++) {
        this.drawText(ctx, this.identifyCode[i], i)
      }
      this.drawLine(ctx)
      this.drawDot(ctx)
    },
    drawText (ctx, txt, i) {
      ctx.fillStyle = this.randomColor(50, 160) // 随机生成字体颜色
      ctx.font = this.randomNum(this.fontSizeMin, this.fontSizeMax) + 'px SimHei' // 随机生成字体大小
      let x = (i + 1) * (this.contentWidth / (this.identifyCode.length + 1))
      let y = this.randomNum(this.fontSizeMax, this.contentHeight - 5)
      var deg = this.randomNum(-30, 30)
      // 修改坐标原点和旋转角度
      ctx.translate(x, y)
      ctx.rotate(deg * Math.PI / 180)
      ctx.fillText(txt, 0, 0)
      // 恢复坐标原点和旋转角度
      ctx.rotate(-deg * Math.PI / 180)
      ctx.translate(-x, -y)
    },
    drawLine (ctx) {
      // 绘制干扰线
      for (let i = 0; i < 4; i++) {
        ctx.strokeStyle = this.randomColor(100, 200)
        ctx.beginPath()
        ctx.moveTo(this.randomNum(0, this.contentWidth), this.randomNum(0, this.contentHeight))
        ctx.lineTo(this.randomNum(0, this.contentWidth), this.randomNum(0, this.contentHeight))
        ctx.stroke()
      }
    },
    drawDot (ctx) {
      // 绘制干扰点
      for (let i = 0; i < 30; i++) {
        ctx.fillStyle = this.randomColor(0, 255)
        ctx.beginPath()
        ctx.arc(this.randomNum(0, this.contentWidth), this.randomNum(0, this.contentHeight), 1, 0, 2 * Math.PI)
        ctx.fill()
      }
    },
    // 切换图片验证码
    changeCode() {
        this.identifyCode = ''
        this.makecode(this.identifyCodes, 4)
        this.$emit('input', this.identifyCode)
        this.drawPic()
    },
    // 生成图片验证码数字
    makecode(data,len) {
        for(let i = 0; i < len; i ++) {
            let min = 0
            let max = data.length
            this.identifyCode = 
            this.identifyCode += data[Math.floor(Math.random() * (max - min) + min)]
        }
    }
  },
  mounted () {
      this.changeCode()
  }
}
</script>
 
<style scoped>
</style>
