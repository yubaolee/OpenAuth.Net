const getters = {
  sidebar: state => state.app.sidebar,
  device: state => state.app.device,
  token: state => state.user.token,
  name: state => state.user.name,
  defaultorgid: state => state.user.defaultorg.id,
  isIdentityAuth: state => state.serverConf.isIdentityAuth,
  modules: state => state.user.modules,
  visitedViews: state => state.tagsView.visitedViews,
  addRouters: state => state.permission.addRouters,
  permission_routers: state => state.permission.routers,
  tenantid:state =>state.tenant.id
}
export default getters
