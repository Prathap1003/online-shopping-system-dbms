/* =========================================================
   ONLINE SHOPPING SYSTEM
   PostgreSQL - DDL
   ========================================================= */


/* =========================================================
   1. CUSTOMER
   ========================================================= */

CREATE TABLE Customer (
    customer_id INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_no VARCHAR(15),
    registration_date DATE NOT NULL
);


/* =========================================================
   2. SELLER
   ========================================================= */

CREATE TABLE Seller (
    seller_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    shop_name VARCHAR(100) NOT NULL UNIQUE,
    gst_number VARCHAR(20) UNIQUE,
    rating REAL,
    total_sales INTEGER,
    bank_account VARCHAR(20),

    CONSTRAINT fk_seller_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    CONSTRAINT chk_seller_rating
        CHECK (rating BETWEEN 0 AND 5),

    CONSTRAINT chk_seller_sales
        CHECK (total_sales >= 0)
);


/* =========================================================
   3. CATEGORY
   ========================================================= */

CREATE TABLE Category (
    category_id INTEGER PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);


/* =========================================================
   4. PRODUCT
   ========================================================= */

CREATE TABLE Product (
    product_id INTEGER PRIMARY KEY,
    seller_id INTEGER NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    category_id INTEGER NOT NULL,
    price REAL NOT NULL,
    discount_pct REAL,
    final_price REAL,
    stock INTEGER,

    CONSTRAINT fk_product_seller
        FOREIGN KEY (seller_id)
        REFERENCES Seller(seller_id),

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES Category(category_id),

    CONSTRAINT chk_product_price
        CHECK (price >= 0),

    CONSTRAINT chk_product_discount
        CHECK (discount_pct BETWEEN 0 AND 100),

    CONSTRAINT chk_product_stock
        CHECK (stock >= 0)
);


/* =========================================================
   5. ADDRESS
   ========================================================= */

CREATE TABLE Address (
    address_id INTEGER PRIMARY KEY,
    street VARCHAR(150) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    country VARCHAR(50) NOT NULL
);


/* =========================================================
   6. CART
   ========================================================= */

CREATE TABLE Cart (
    cart_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    added_at DATE,

    CONSTRAINT fk_cart_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    CONSTRAINT fk_cart_product
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id),

    CONSTRAINT chk_cart_quantity
        CHECK (quantity > 0)
);


/* =========================================================
   7. ORDERS
   ========================================================= */

CREATE TABLE Orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    address_id INTEGER NOT NULL,
    total_amount REAL,
    order_status VARCHAR(30),
    estimated_delivery DATE,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    CONSTRAINT fk_order_address
        FOREIGN KEY (address_id)
        REFERENCES Address(address_id),

    CONSTRAINT chk_order_amount
        CHECK (total_amount >= 0),

    CONSTRAINT chk_order_status
        CHECK (
            order_status IN
            ('Placed', 'Shipped', 'Delivered', 'Cancelled')
        )
);


/* =========================================================
   8. PAYMENT
   ========================================================= */

CREATE TABLE Payment (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    payment_date DATE NOT NULL,
    payment_method VARCHAR(30),
    amount REAL,
    payment_status VARCHAR(30),
    transaction_id VARCHAR(100) UNIQUE,

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT chk_payment_amount
        CHECK (amount >= 0),

    CONSTRAINT chk_payment_method
        CHECK (
            payment_method IN
            ('UPI', 'Card', 'Net Banking', 'Cash on Delivery')
        ),

    CONSTRAINT chk_payment_status
        CHECK (
            payment_status IN
            ('Pending', 'Completed', 'Failed', 'Refunded')
        )
);


/* =========================================================
   9. REVIEW
   ========================================================= */

CREATE TABLE Review (
    review_id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    rating INTEGER NOT NULL,
    comment_text VARCHAR(1000),
    review_date DATE,

    CONSTRAINT fk_review_product
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id),

    CONSTRAINT fk_review_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    CONSTRAINT chk_review_rating
        CHECK (rating BETWEEN 1 AND 5)
);


/* =========================================================
   10. RETURNS
   ========================================================= */

CREATE TABLE Return(
    return_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    reason VARCHAR(1000),
    return_date DATE,
    status VARCHAR(20),
    refund_amount REAL,

    CONSTRAINT fk_return_order
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT fk_return_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    CONSTRAINT chk_return_status
        CHECK (
            status IN
            ('Requested', 'Approved', 'Refunded')
        ),

    CONSTRAINT chk_refund_amount
        CHECK (refund_amount >= 0)
);
