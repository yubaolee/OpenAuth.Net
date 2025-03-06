/*
 * @Author: yubaolee <yubaolee@163.com> | ahfu~ <954478625@qq.com>
 * @Date: 2024-11-29 22:16:54
 * @LastEditTime: 2025-03-06 23:29:51
 * @Description: 
 * Copyright (c) 2025 by yubaolee | ahfu~ , All Rights Reserved.  
 */

layui.define("jquery", function (exports) {
    var jQuery = layui.jquery,
        $ = layui.jquery;

    //获取url的参数值
    $.getUrlParam = function (name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]); return null;
    }

    //把name/value的数组转为obj对象
    $.arrayToObj = function (array) {
        var result = {};
        for (var i = 0; i < array.length; i++) {
            var field = array[i];
            if (field.name in result) {
                result[field.name] += ',' + field.value;
            } else {
                result[field.name] = field.value;
            }
        }
        return result;
    }

    //加载菜单
    $.fn.extend({
        loadMenus: function (modulecode) {
            var dom = $(this);
            $.ajax("/ModuleManager/LoadAuthorizedMenus?modulecode=" + modulecode,
                {
                    async: false
                    , success: function (data) {
                        var obj = JSON.parse(data);
                        var sb = '';
                        $.each(obj,
                            function () {
                                var element = this;
                                sb += ("<button " + " data-type='" + element.DomId +
                                    "' " + " class='layui-btn layui-btn-small " + element.Class +
                                    "' " + element.Attr + ">");

                                if (element.Icon != null && element.Icon != '') {
                                    sb += ("<i class='layui-icon " + element.Icon + "'></i>");
                                }
                                sb += (element.Name + "</button>");
                            });

                        dom.html(sb);
                    }
                });
        }
    });

    // 修改laytable点击行选中checkbox
    clickTableRow = function (table, id, filter) {
        // 监听行单击事件
        table.on('row(' + filter + ')', function (obj) {
            // 先取消所有行的checkbox的选中状态
            var tableBox = obj.tr.parents('.layui-table-box');
            tableBox.find('.layui-table-body tr').each(function () {
                $(this).find('input[type="checkbox"]').prop('checked', false);
                var index = $(this).data('index');
                table.cache[id][index].LAY_CHECKED = false;
            });

            // 取消选中行
            table.setRowChecked(id, {
                index: 'all', // 所有行
                checked: false // 此处若设置 true，则表示全选
            });


            // 设置当前行选中,这个方法可以让checkStatus（）获取到值，但它不能改变checkbox的选中状态😓
            table.setRowChecked(id, {
                index: obj.tr.data('index')
            });

            // 设置当前行checkbox 选中
            obj.tr.find('input[type="checkbox"]').prop('checked', true);
            obj.data.LAY_CHECKED = true;

        });
    }

    exports('utils');
});