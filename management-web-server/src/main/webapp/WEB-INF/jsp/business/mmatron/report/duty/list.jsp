<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="../../../../common/resource.jsp" %>
    <%@ include file="../../../../common/tags.jsp" %>

    <title>护理师勤务报表</title>
    <!-- Bootstrap core CSS -->
    <link href="${ctx}/static/css/bootstrap.css" rel="stylesheet">
    <link href="${ctx}/static/layui/css/layui.css" rel="stylesheet">
    <link href="${ctx}/static/css/style.css?v=${webVersion}" rel="stylesheet">
    <link href="${ctx}/static/css/paginate.css" rel="stylesheet">
    <style>
        .detail {
            color: #1E9FFF;
            cursor: pointer;
        }
    </style>
</head>

<body class="layui-layout-body">

<div class="layui-layout layui-layout-admin">
    <!--header start-->
    <jsp:include page="../../../../header.jsp"/>
    <!--header end-->
    <!--sidebar start-->
    <jsp:include page="../../../../aside.jsp"/>
    <!--sidebar end-->
    <!--main content start-->
    <div class="layui-body">
        <div class="form-panel">
            <div class="panel-heading">
                <h5 class="mb"><i class="fa fa-list-ul"></i>护理师勤务</h5>
            </div>


            <div class="form-horizontal style-form ">
                <form class="layui-form">
                    <div class="layui-form-item layui-row">

                        <div class="layui-inline layui-col-md8">
                            <div class="layui-inline">
                                <label class="layui-form-label">开始时间</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="startDate" id="startDate" readonly autocomplete="off"
                                           class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">结束时间</label>
                                <div class="layui-input-inline">
                                    <input type="text" name="endDate" id="endDate" readonly autocomplete="off"
                                           class="layui-input">
                                </div>
                            </div>
                            <div class="layui-inline">
                                <label class="layui-form-label">护理师姓名</label>
                                <div class="layui-input-inline">
                                    <input id="mmatronName" name="mmatronName" class="layui-input" type="text"/>
                                </div>
                            </div>

                            <div class="layui-inline">
                                <label class="layui-form-label">会所</label>
                                <div class="layui-input-inline">
                                    <select name="subsyCode" lay-search>
                                        <option value="">请选择</option>
                                        <c:forEach items="${subsyList}" var="subsy">
                                            <option value="${subsy.subsyCode}">${subsy.subsyDispName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                        </div>
                        <div class="layui-inline layui-col-md3">
                            <button class="layui-btn layui-btn-normal" lay-submit lay-filter="search">查 询</button>
                            <button type="reset" class="layui-btn layui-btn-normal">清 空</button>
                        </div>

                    </div>
                </form>
                <div class="form-group">
                    <div class="col-xs-12 mt">

                        <div class="content-panel">
                            <table id="table_data" class="dataTable table table-hover">
                                <thead>
                                <tr>
                                    <th style="width: 5%;">#</th>
                                    <th style="width: 8%;">护理师姓名</th>
                                    <th style="width: 10%;">所属单位</th>
                                    <th style="width: 10%;">护理师等级</th>
                                    <th style="width: 10%;">上单天数</th>
                                    <th style="width: 10%;">请假天数</th>
                                    <th style="width: 10%;">空闲天数</th>
                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--main content end-->
    <jsp:include page="../../../../footer.jsp"/>
</div>

<!-- js placed at the end of the document so the pages load faster -->
<script src="${ctx}/static/layui/layui.js?v=${webVersion}"></script>
<script src="${ctx}/static/js/global.js?v=${webVersion}"></script>
<script>
    //JavaScript代码区域
    layui.use(['element', 'layer', 'globalAjax', 'datatable', 'laydate', 'jquery', 'form'], function () {
        var $ = layui.jquery, datatable = layui.datatable, form = layui.form, laydate = layui.laydate;
        $("#startDate").val(getCurrentMonthFirst());
        $("#endDate").val(getToday());
        //日期前后联动
        var startDate = laydate.render({
            elem: '#startDate',
            btns: ['confirm'],
            done: function (value, date) {
                endDate.config.min = {
                    year: date.year,
                    month: date.month - 1,
                    date: date.date
                }
            }
        });

        var endDate = laydate.render({
            elem: '#endDate',
            btns: ['confirm'],
            done: function (value, date) {
                startDate.config.max = {
                    year: date.year,
                    month: date.month - 1,
                    date: date.date
                }
            }
        });

        $(function () {
            initTable(getCurrentMonthFirst(), getToday(), "", "")
        });

        form.on('submit(search)', function (data) {
            initTable(data.field.startDate, data.field.endDate, data.field.subsyCode, data.field.mmatronName);
            return false;
        });


        //初始化表格
        function initTable(startDate, endDate, subsyCode, mmatronName) {
            $("#table_data").dataTable().fnDestroy();
            json = {};
            json.id = "table_data";
            json.url = '${ctx}/mmatronReport/mmatronDutyDataList';
            json.param = [{
                name: "startDate",
                value: startDate
            }, {
                name: "endDate",
                value: endDate
            }, {
                name: "mmatronName",
                value: mmatronName
            }, {
                name: "subsyCode",
                value: subsyCode
            }];
            json.columns = [
                {
                    "sWidth": "60px",
                    "sClass": "text-center"
                }, {
                    "mData": "mmatronName",
                    "sWidth": "180px",
                    "sClass": "text-center"
                }, {
                    "mData": "subsyName",
                    "sWidth": "180px",
                    "sClass": "text-center",
                }, {
                    "mData": "gradeName",
                    "sWidth": "180px",
                    "sClass": "text-center",
                }, {
                    "mData": "workingDays",
                    "sWidth": "200px",
                    "sClass": "text-center",
                    "mRender": function (data, type, row) {
                        return "<span class=\"detail\" " +
                            "vb=\"" + row.mmatronBaseCode + "\" " +
                            "vbStartDate=\"" + startDate + "\" " +
                            "vbScheduleType=\"00860002\" " +
                            "vbEndDate=\"" + endDate + "\">" + row.workingDays + "</span>"
                    }
                }, {
                    "mData": "leavingDays",
                    "sWidth": "200px",
                    "sClass": "text-center",
                    "mRender": function (data, type, row) {
                        return "<span class=\"detail\" " +
                            "vb=\"" + row.mmatronBaseCode + "\" " +
                            "vbStartDate=\"" + startDate + "\" " +
                            "vbScheduleType=\"00860001\" " +
                            "vbEndDate=\"" + endDate + "\">" + row.leavingDays + "</span>"
                    }
                }, {
                    "mData": "spareDays",
                    "sWidth": "200px",
                    "sClass": "text-center"
                }
            ];
            datatable.tableManaged(json).init();
        }


        $(document).on('click', ".detail", function () {
            if ($(this).html() === "0") {
                layer.alert("暂无明细信息");
                return;
            }
            var mmatronBaseCode = $(this).attr("vb");
            var scheduleType = $(this).attr("vbScheduleType");
            var startDate = $(this).attr("vbStartDate");
            var endDate = $(this).attr("vbEndDate");
            $.post("${ctx}/mmatronReport/getScheduleListByCondition", {
                mmatronBaseCode: mmatronBaseCode,
                scheduleType: scheduleType,
                startDate: startDate,
                endDate: endDate
            }, function (data) {
                var array = [];
                array.push('<table class="table" id="layer_Box" >');
                array.push('<thead>');
                array.push('<tr>');
                array.push('<th>#</th>');
                array.push('<th>日期</th>');
                array.push('</tr>');
                array.push('</thead>');
                array.push("<tbody>");
                for (var i = 0; i < data.length; i++) {
                    array.push("<tr>");
                    array.push("<td>#" + (i + 1) + "</td>");
                    array.push("<td>" + data[i].workDate + "</td>");
                    array.push("</tr>");
                }
                array.push("</tbody></table>");
                var title = "";
                if(scheduleType === "00860002") {
                    title = data[0].mmatronName + '上单日期明细';
                } else{
                    title = data[0].mmatronName + '请假日期明细';
                }
                layer.open({
                    title: title
                    , resize: false
                    , area: ['800px', '600px']
                    , move: false
                    , content: array.join("")

                })
            })

        });

    });


</script>
</body>
</html>
