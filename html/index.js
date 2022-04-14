$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://VehicleController/exit', JSON.stringify({}));
            return
        }
    };
    $("#close").click(function () {
        $.post('http://VehicleController/exit', JSON.stringify({}));
        return
    })

	//when the user clicks on the lock button, it will run
    $("#lock").click(function () {
        $.post('http://VehicleController/togglelock');
        return;
    })
	
	//when the user clicks on the hotwire button, it will run
    $("#toggleengine").click(function () {
        $.post('http://VehicleController/toggleengine');
        return;
    })
	
	//when the user clicks on the hotwire button, it will run
    $("#headlights").click(function () {
        $.post('http://VehicleController/headlights');
        return;
    })
})