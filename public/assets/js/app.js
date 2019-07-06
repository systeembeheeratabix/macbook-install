$(document).ready(function() {
    updateChecker();
});

var updateChecker = function() {
    $.ajax({
        method: 'GET',
        url: '/update',
        success: function(data) {
            if (data && data.is_updateable) {
                updateAvailableNotification();
                updateFetch();
            }
        }
    });
};

var updateFetch = function() {
    $.ajax({
        method: 'POST',
        url: '/update',
        success: function(data) {
            if (data && data.success) {
                return updateSuccessNotification();
            }

            return updateFailedNotification();
        }
    });
};

var updateAvailableNotification = function() {
    toastr.info("There is a new version of the help dashboard available.", "Update Available", {
        timeOut: 5000,
    });
}

var updateSuccessNotification = function() {
    toastr.success("The help dashboard has been successfully updated. Refreshing automatically.", "Update Completed", {
        onHidden: function() {
            window.location.reload();
        }
    });
}

var updateFailedNotification = function() {
    toastr.info("There was a problem with updating the help dashboard.", "Update Failed");
}

toastr.options = {
    closeButton: false,
    debug: false,
    newestOnTop: true,
    progressBar: true,
    positionClass: "toast-bottom-right",
    preventDuplicates: false,
    showDuration: "300",
    hideDuration: "1000",
    timeOut: "10000",
    extendedTimeOut: "1000",
    showEasing: "swing",
    hideEasing: "linear",
    showMethod: "fadeIn",
    hideMethod: "fadeOut"
};
