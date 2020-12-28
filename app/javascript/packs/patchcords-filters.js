$(document).ready(function() {
    $('#from-box').change(function(event){
        boxId = $(this).val();
        var selectOwner = $('#from-owner');
        var selectInterface = $('#from-interface');
        var selectToBox = $('#to-box');
        selectInterface.attr("disabled", true);
        selectOwner.empty();
        selectOwner.append('<option value=""></option>');
        if (boxId) {
            $.ajax({
                type: "GET",
                url: '/box_children/' + boxId,
                success: function (data) {
                    data.forEach(element => {
                        selectOwner.append('<option value="' + element.id + '">' + element.name + '</option>');
                    });
                    selectOwner.removeAttr("disabled");
                    selectToBox.removeAttr("disabled");
                }
            });
        } else {
            selectOwner.attr("disabled", true);
        }
    });

    $('#from-owner').change(function(event){
        ownerId = $(this).val();
        var selectInterface = $('#from-interface');
        selectInterface.empty();
        selectInterface.append('<option value=""></option>');
        if (ownerId) {
            $.ajax({
                type: "GET",
                url: '/get_interfaces/' + ownerId,
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
        var selectOwner = $('#to-owner');
        var selectInterface = $('#to-interface');
        selectInterface.attr("disabled", true);
        selectOwner.empty();
        selectOwner.append('<option value=""></option>');
        if (boxId) {
            $.ajax({
                type: "GET",
                url: '/box_children/' + boxId,
                success: function (data) {
                    data.forEach(element => {
                        selectOwner.append('<option value="' + element.id + '">' + element.name + '</option>');
                    });
                    selectOwner.removeAttr("disabled");
                }
            });
        } else {
            selectOwner.attr("disabled", true);
        }
    });

    $('#to-owner').change(function(event){
        ownerId = $(this).val();
        var selectInterface = $('#to-interface');
        selectInterface.empty();
        selectInterface.append('<option value=""></option>');
        if (ownerId) {
            $.ajax({
                type: "GET",
                url: '/get_interfaces/' + ownerId,
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