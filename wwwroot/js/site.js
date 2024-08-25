$('.delete-form').each(function (index) {
    $(this).submit(e => {
        e.preventDefault();
        Swal.fire({
            title: "Are you sure?",
            text: "Do you really want to delete this record? This process cannot be undone.",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#3085d6",
            cancelButtonColor: "#d33",
            confirmButtonText: "Submit"
        }).then((result) => {
            if (result.isConfirmed) {
                $(this).unbind();
                $(this).submit();
            }
        });
    });
});