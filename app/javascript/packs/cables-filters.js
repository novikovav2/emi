$(document).ready(function() {
    $('#from-box').change(function(event){
        boxId = $(this).val();
        var selectPatchpanel = $('#from-patchpanel');
        var selectInterface = $('#from-interface');
        selectInterface.attr("disabled", true);
        selectPatchpanel.empty();
        selectPatchpanel.append('<option value=""></option>');
        if (boxId) {
            $.ajax({
                type: "GET",
                url: '/patchpanels.json',
                data: {box_id: boxId},
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
                url: '/patchpanels/' + patchpanelId + '/interfaces.json',
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

    $('#to-box').change(function(event){
        boxId = $(this).val();
        var selectPatchpanel = $('#to-patchpanel');
        var selectInterface = $('#to-interface');
        selectInterface.attr("disabled", true);
        selectPatchpanel.empty();
        selectPatchpanel.append('<option value=""></option>');
        if (boxId) {
            $.ajax({
                type: "GET",
                url: '/patchpanels.json',
                data: {box_id: boxId},
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
                url: '/patchpanels/' + patchpanelId + '/interfaces.json',
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