document.addEventListener("DOMContentLoaded", function() {
    let editProductId = null;

    // Hàm tải danh sách sản phẩm
    function loadProducts() {
        fetch("http://127.0.0.1:5000/products")
            .then(response => response.json())
            .then(products => {
                let list = document.getElementById("product-list");
                list.innerHTML = "";
                products.forEach(product => {
                    let row = document.createElement("tr");
                    row.innerHTML = `
                        <td>${product._id}</td>
                        <td>${product.name}</td>
                        <td>${product.price}</td>
                        <td>
                            <button onclick="editProduct('${product._id}', '${product.name}', '${product.price}')">Edit</button>
                            <button onclick="deleteProduct('${product._id}')">Delete</button>
                        </td>
                    `;
                    list.appendChild(row);
                });
            });
    }

    // Thêm sản phẩm mới
    document.getElementById("submit-product").addEventListener("click", function() {
        let name = document.getElementById("product-name").value;
        let price = document.getElementById("product-price").value;
    
        // Biểu thức chính quy để kiểm tra ký tự đặc biệt
        const invalidChars = /[!@#$%^&*(),.?":{}|<>]/g;
    
        if (!name.trim() || !price.trim()) {
            document.getElementById("error-message").style.display = "block";
            document.getElementById("error-message").innerText = "Please fill in all fields with valid data.";
        } else if (invalidChars.test(name) || invalidChars.test(price)) {
            document.getElementById("error-message").style.display = "block";
            document.getElementById("error-message").innerText = "Please do not enter special characters.";
        } else {
            document.getElementById("error-message").style.display = "none";
            fetch("http://127.0.0.1:5000/product", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ name, price })
            }).then(() => loadProducts());
        }
    });

    // Xóa sản phẩm
    window.deleteProduct = function(id) {
        fetch(`http://127.0.0.1:5000/product/${id}`, { method: "DELETE" })
            .then(() => loadProducts());
    };

    // Chỉnh sửa thông tin sản phẩm
    window.editProduct = function(id, name, price) {
        editProductId = id;
        document.getElementById("edit-product-name").value = name;
        document.getElementById("edit-product-price").value = price;
    };

    // Cập nhật thông tin sản phẩm
    document.getElementById("edit-product-button").addEventListener("click", function() {
        let name = document.getElementById("edit-product-name").value;
        let price = document.getElementById("edit-product-price").value;

        // Kiểm tra xem các trường có bị bỏ trống không
        if (!name || !price || name === "" || price === "") {
            document.getElementById("edit-error-message").style.display = "block";  // Hiển thị thông báo lỗi nếu có trường trống
        } else {
            document.getElementById("edit-error-message").style.display = "none";  // Ẩn thông báo lỗi nếu tất cả trường hợp lệ
            if (editProductId) {
                fetch(`http://127.0.0.1:5000/product/${editProductId}`, {
                    method: "PUT",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ name, price })
                }).then(() => loadProducts());
            }
        }
    });

    loadProducts();
});
