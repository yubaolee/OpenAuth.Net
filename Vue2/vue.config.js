const path = require('path')
function resolve (dir) {
    return path.join(__dirname, '/', dir)
}

module.exports = {
  runtimeCompiler:true,
  configureWebpack: {
    devtool: 'source-map'
},
  productionSourceMap: false,
  lintOnSave: process.env.NODE_ENV !== 'production',
  devServer: {
    port: 1803,     // 端口
    overlay: {
      warnings: true,
      errors: false
    }
  }
}