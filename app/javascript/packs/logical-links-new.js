$(document).ready(function() {
    $('#from-device').change(function(event){
        deviceId = $(this).val();
        var selectInterface = $('#from-interface');
        selectInterface.attr("disabled", true);
        selectInterface.empty();
        selectInterface.append('<option value=""></option>');
        if (deviceId) {
            $.ajax({
                type: "GET",
                url: '/get_interfaces/' + deviceId,
                data: {
                    without_logical_links: true
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

    $('#to-device').change(function(event){
        deviceId = $(this).val();
        var selectInterface = $('#to-interface');
        selectInterface.attr("disabled", true);
        selectInterface.empty();
        selectInterface.append('<option value=""></option>');
        if (deviceId) {
            $.ajax({
                type: "GET",
                url: '/get_interfaces/' + deviceId,
                data: {
                    without_logical_links: true
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