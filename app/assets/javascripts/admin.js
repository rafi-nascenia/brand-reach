/**
 * Created by sumon on 12/8/15.
 */

$(function () {
    /* ====== deactivate active user ==============*/
    $('.activate-user').click(function () {
        var userId = $(this).data('id');

        bootbox.confirm({
            message: 'Do you really want to activate this user?',
            closeButton: false,
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type: 'put',
                        url: '/admins/' + userId + '/activate_user',
                        dataType: "script",
                        data: {
                            'authenticity_token': $('meta[name="csrf-token"]').attr('content')
                        },
                        success: function (data) {
                            console.log(data)
                        }
                    });
                }
            }
        });
    });

    /* ====== deactivate active user ==============*/
    $('.deactivate-user').click(function () {
        var userId = $(this).data('id');

        bootbox.confirm({
            message: "Do you really want to deactivate this user?",
            closeButton: false,
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type: 'put',
                        url: '/admins/' + userId + '/deactivate_user',
                        dataType: "script",
                        data: {
                            'authenticity_token': $('meta[name="csrf-token"]').attr('content')
                        },
                        success: function (data) {
                            console.log(data)
                        }
                    });
                }
            }
        });
    });

    $('.make-celebrity').click(function () {
        var userId = $(this).data('id');

        bootbox.confirm({
            message: "Do you really want to make this influencer to Celebrity?",
            closeButton: false,
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type: 'put',
                        url: '/admins/' + userId + '/make_celebrity',
                        dataType: "script",
                        data: {
                            'authenticity_token': $('meta[name="csrf-token"]').attr('content')
                        },
                        success: function (data) {
                            console.log(data)
                        }
                    });
                }
            }
        });
    });

    $('.make-community').click(function () {
        var userId = $(this).data('id');

        bootbox.confirm({
            message: "Do you really want to make this influencer to Community?",
            closeButton: false,
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type: 'put',
                        url: '/admins/' + userId + '/make_community',
                        dataType: "script",
                        data: {
                            'authenticity_token': $('meta[name="csrf-token"]').attr('content')
                        },
                        success: function (data) {
                            console.log(data)
                        }
                    });
                }
            }
        });
    });

    $('.remove-admin').click(function () {
        var adminId = $(this).data('id');

        bootbox.confirm({
            message: 'Do you really want to remove this admin?',
            closeButton: false,
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type: 'delete',
                        url: '/admins/' + adminId,
                        dataType: "script",
                        data: {
                            'authenticity_token': $('meta[name="csrf-token"]').attr('content')
                        },
                        success: function (data) {
                            console.log(data)
                        }
                    });
                }
            }
        });
    });

/*=== delete user =========*/
    $('.js-remove-user').click(function () {
        var userId = $(this).data('id');

        bootbox.confirm({
            message: 'Do you really want to delete this user?',
            closeButton: false,
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type: 'delete',
                        url: '/admins/' + userId + '/delete_user',
                        dataType: "script",
                        data: {
                            'authenticity_token': $('meta[name="csrf-token"]').attr('content')
                        },
                        success: function (data) {
                            console.log(data)
                        }
                    });
                }
            }
        });
    });



    /*=== delete campaign =========*/
    $('.js-remove-celebrity-campaign').click(function () {
        var campaign_id = $(this).data('id');

        bootbox.confirm({
            message: 'Do you really want to delete this campaign?',
            closeButton: false,
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type: 'delete',
                        url: '/admins/' + campaign_id + '/remove_celebrities_campaign',
                        dataType: "script",
                        data: {
                            'authenticity_token': $('meta[name="csrf-token"]').attr('content')
                        },
                        success: function (data) {
                            console.log(data)
                        }
                    });
                }
            }
        });
    });


/*========== make influencer payment request paid =====*/
    $('.js-make-payment-paid').click(function(){
        var paymentId = $(this).data('id');

        bootbox.confirm({
            message: 'Do you really want to make paid this payment?',
            closeButton: false,
            callback: function (result) {
                if (result) {
                    $.ajax({
                        type: 'put',
                        url: '/admins/make_payment_paid' ,
                        dataType: "script",
                        data: {
                            'authenticity_token': $('meta[name="csrf-token"]').attr('content'),
                            'payment_id': paymentId
                        },
                        success: function (data) {
                            console.log(data)
                        }
                    });
                }
            }
        });
    });

});
