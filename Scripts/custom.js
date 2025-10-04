$(document).ready(function () {
    // Initialize tooltips
    $('[data-toggle="tooltip"]').tooltip();

    // Initialize popovers
    $('[data-toggle="popover"]').popover();

    // Confirm delete actions
    $('.btn-danger').click(function (e) {
        if (!confirm('Bạn có chắc chắn muốn xóa không?')) {
            e.preventDefault();
        }
    });

    // Auto-hide alerts after 5 seconds
    setTimeout(function () {
        $('.alert').fadeOut('slow');
    }, 5000);

    // Format currency inputs
    $('.currency-input').on('blur', function () {
        var value = $(this).val();
        if (value && !isNaN(value)) {
            $(this).val(parseFloat(value).toLocaleString('vi-VN'));
        }
    });

    // Search functionality
    $('#search-form').on('submit', function (e) {
        var searchTerm = $('#search-input').val().trim();
        if (searchTerm === '') {
            e.preventDefault();
            alert('Vui lòng nhập từ khóa tìm kiếm');
        }
    });

    // Product image lazy loading
    $('img[data-src]').each(function () {
        var img = $(this);
        img.attr('src', img.data('src'));
    });

    // Order status update confirmation
    $('.status-update-btn').click(function (e) {
        var status = $(this).data('status');
        var statusText = $(this).text();
        
        if (!confirm('Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng thành "' + statusText + '"?')) {
            e.preventDefault();
        }
    });

    // Form validation
    $('form').on('submit', function () {
        var isValid = true;
        
        // Check required fields
        $(this).find('[required]').each(function () {
            if ($(this).val().trim() === '') {
                $(this).addClass('error');
                isValid = false;
            } else {
                $(this).removeClass('error');
            }
        });
        
        if (!isValid) {
            alert('Vui lòng điền đầy đủ thông tin bắt buộc');
            return false;
        }
    });

    // Remove error class on input
    $('input, textarea, select').on('input change', function () {
        $(this).removeClass('error');
    });

    // Add loading spinner to buttons
    $('.btn').on('click', function () {
        var btn = $(this);
        if (btn.attr('type') === 'submit') {
            btn.prop('disabled', true);
            btn.html('<span class="loading"></span> Đang xử lý...');
        }
    });
});

// Utility functions
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

function showAlert(message, type) {
    type = type || 'info';
    var alertHtml = '<div class="alert alert-' + type + ' alert-dismissible" role="alert">' +
        '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
        '<span aria-hidden="true">&times;</span></button>' +
        message + '</div>';
    
    $('.body-content').prepend(alertHtml);
    
    setTimeout(function () {
        $('.alert').fadeOut('slow');
    }, 5000);
}

// AJAX helper functions
function makeAjaxRequest(url, data, successCallback, errorCallback) {
    $.ajax({
        url: url,
        type: 'POST',
        data: data,
        success: function (response) {
            if (successCallback) successCallback(response);
        },
        error: function (xhr, status, error) {
            if (errorCallback) errorCallback(xhr, status, error);
            else showAlert('Có lỗi xảy ra: ' + error, 'danger');
        }
    });
}
