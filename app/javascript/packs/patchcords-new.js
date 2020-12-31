$(document).ready(function() {
    $('#from-room').change(function(event){
        roomId = $(this).val();
        var fromBox = $('#from-box');
        var fromPatchpanel = $('#from-patchpanel');
        var selectInterface = $('#from-interface');
        fromPatchpanel.attr("disabled", true);
        selectInterface.attr("disabled", true);
        fromBox.empty();
        fromPatchpanel.empty();
        selectInterface.empty();
        fromBox.append('<option value=""></option>');
        if (roomId) {
            $.ajax({
                type: "GET",
                url: '/get_boxes/' + roomId,
                success: function (data) {
                    data.forEach(element => {
                        fromBox.append('<option value="' + element.id + '">' + element.name + '</option>');
                    });
                    fromBox.removeAttr("disabled");
                }
            });
        } else {
            fromBox.attr("disabled", true);
        }
    });

    $('#from-box').change(function(event){
        boxId = $(this).val();
        var selectPatchpanel = $('#from-patchpanel');
        var selectInterface = $('#from-interface');
        selectInterface.attr("disabled", true);
        selectPatchpanel.empty();
        selectInterface.empty();
        selectPatchpanel.append('<option value=""></option>');
        if (boxId) {
            $.ajax({
                type: "GET",
                url: '/box_children/' + boxId,
                success: function (data) {
                    data.forEach(element => {
                        selectPatchpanel.append('<option value="' + element.id + '">' + element.name + '</option>');
                    });
                    selectPatchpanel.removeAttr("disabled");
                }
            });
        } else {
            selectPatchpanel.attr("disabled", true);
        }
    });

    $('#from-patchpanel').change(function(event){
        patchpanelId = $(this).val();
        var selectInterface = $('#from-interface');
        selectInterface.empty();
        selectInterface.append('<option value=""></option>');
        if (patchpanelId) {
            $.ajax({
                type: "GET",
                url: '/get_interfaces/' + patchpanelId,
                data: {
                    without_patchcords: true
                },
                success: function (data) {
                    data.forEach(element => {
                        selectInterface.append('<option value="' + element.id + '">' + element.name + '</option>');
                    });
                    selectInterface.removeAttr("disabled");
                }
            });
        } else {
            selectInterface.attr("disabled", true);
        }
    });

    $('#to-room').change(function(event){
        roomId = $(this).val();
        var toBox = $('#to-box');
        var toPatchpanel = $('#to-patchpanel');
        var selectInterface = $('#to-interface');
        toPatchpanel.attr("disabled", true);
        selectInterface.attr("disabled", true);
        toBox.empty();
        toPatchpanel.empty();
        selectInterface.empty();
        toBox.append('<option value=""></option>');
        if (roomId) {
            $.ajax({
                type: "GET",
                url: '/get_boxes/' + roomId,
                success: function (data) {
                    data.forEach(element => {
                        toBox.append('<option value="' + element.id + '">' + element.name + '</option>');
                    });
                    toBox.removeAttr("disabled");
                }
            });
        } else {
            toBox.attr("disabled", true);
        }
    });

    $('#to-box').change(function(event){
        boxId = $(this).val();
        var selectPatchpanel = $('#to-patchpanel');
        var selectInterface = $('#to-interface');
        selectInterface.attr("disabled", true);
        selectInterface.empty();
        selectPatchpanel.empty();
        selectPatchpanel.append('<option value=""></option>');
        if (boxId) {
            $.ajax({
                type: "GET",
                url: '/box_children/' + boxId,
                success: function (data) {
                    data.forEach(element => {
                        selectPatchpanel.append('<option value="' + element.id + '">' + element.name + '</option>');
                    });
                    selectPatchpanel.removeAttr("disabled");
                }
            });
        } else {
            selectPatchpanel.attr("disabled", true);
        }
    });

    $('#to-patchpanel').change(function(event){
        patchpanelId = $(this).val();
        var selectInterface = $('#to-interface');
        selectInterface.empty();
        selectInterface.append('<option value=""></option>');
        if (patchpanelId) {
            $.ajax({
                type: "GET",
                url: '/get_interfaces/' + patchpanelId,
                data: {
                    without_patchcords: true
                },
                success: function (data) {
                    data.forEach(element => {
                        selectInterface.append('<option value="' + element.id + '">' + element.name + '</option>');
                    });
                    selectInterface.removeAttr("disabled");
                }
            });
        } else {
            selectInterface.attr("disabled", true);
        }
    });

})